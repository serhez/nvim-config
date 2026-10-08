-- Symbols from CodeDiff revisions without setting filetype or attaching an LSP.
local M = { name = "codediff" }

local kinds = require("outline.symbols").str_to_kind
local capture_kinds = {
	["local.definition.function"] = kinds.Function,
	["local.definition.method"] = kinds.Method,
	["local.definition.type"] = kinds.Class,
	["local.definition.var"] = kinds.Variable,
	["local.definition.field"] = kinds.Field,
}

local ecma_declarations = {
	class_declaration = kinds.Class,
	interface_declaration = kinds.Interface,
	type_alias_declaration = kinds.TypeAlias,
	enum_declaration = kinds.Enum,
}

local declarations = {
	class_definition = true,
	class_declaration = true,
	function_definition = true,
	function_declaration = true,
	method_definition = true,
	method_declaration = true,
	type_declaration = true,
	type_spec = true,
	interface_declaration = true,
	enum_declaration = true,
	lexical_declaration = true,
	variable_declaration = true,
	assignment_statement = true,
	short_var_declaration = true,
	var_spec = true,
	const_spec = true,
	field_definition = true,
}

local function bounds(node)
	local start_line, start_col, end_line, end_col = node:range()
	return { start = { line = start_line, character = start_col }, ["end"] = { line = end_line, character = end_col } }
end

local function enclosing_declaration(node)
	local current = node:parent()
	while current do
		if declarations[current:type()] then
			return current
		end
		current = current:parent()
	end
	return node
end

local function markdown_symbols(symbols)
	for _, symbol in ipairs(symbols) do
		symbol.kind = kinds.Namespace
		markdown_symbols(symbol.children or {})
	end
	return symbols
end

function M.supports_buffer(bufnr)
	if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
	-- The revision part may contain symbolic refs, but the file path follows it.
	local _, relative = vim.api.nvim_buf_get_name(bufnr):match("^codediff:///(.-)///[^/]+/(.+)$")
	if not relative then
		local lifecycle = package.loaded["codediff.ui.lifecycle"]
		if not lifecycle then return false end
		local tab = vim.api.nvim_get_current_tabpage()
		local _, win = lifecycle.get_windows(tab)
		if not win or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= bufnr then
			return false
		end
		local original, modified = lifecycle.get_paths(tab)
		local selected = (modified and modified.relative ~= "" and modified)
			or (original and original.relative ~= "" and original)
		relative = selected and selected.relative
		if not relative or vim.bo[bufnr].buftype == "" then return false end
	end
	local ft = vim.filetype.match({ filename = relative })
	if ft == "markdown" or ft == "quarto" or ft == "rmd" then
		return true, { buf = bufnr, markdown = true }
	end
	if not ft then
		return false
	end
	local lang = vim.treesitter.language.get_lang(ft) or ft
	local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
	local query_ok, query = pcall(vim.treesitter.query.get, lang, "locals")
	if not parser_ok or not parser or not query_ok or not query then
		return false
	end
	return true, { buf = bufnr, parser = parser, query = query, lang = lang }
end

function M.request_symbols(callback, opts, info)
	if info.markdown then
		local symbols = vim.api.nvim_buf_call(info.buf, require("outline.providers.markdown").handle_markdown)
		symbols = markdown_symbols(symbols)
		callback(symbols, opts)
		return
	end

	local tree = info.parser:parse()[1]
	local symbols, seen = {}, {}
	local function add_symbol(node, declaration, kind)
		local name = vim.treesitter.get_node_text(node, info.buf)
		local selection = bounds(node)
		local key = selection.start.line .. ":" .. selection.start.character .. ":" .. name
		if not seen[key] then
			seen[key] = true
			symbols[#symbols + 1] = {
				name = name,
				kind = kind,
				range = bounds(declaration),
				selectionRange = selection,
				children = {},
			}
		end
	end
	for id, node in info.query:iter_captures(tree:root(), info.buf) do
		local capture = info.query.captures[id]
		local kind = capture_kinds[capture]
		if kind then
			add_symbol(node, enclosing_declaration(node), kind)
		end
	end
	if info.lang == "javascript" or info.lang == "typescript" or info.lang == "tsx" then
		local function add_declarations(node)
			local kind = ecma_declarations[node:type()]
			if kind then
				local name = node:field("name")[1]
				if name then add_symbol(name, node, kind) end
			end
			for child in node:iter_children() do add_declarations(child) end
		end
		add_declarations(tree:root())
	end

	table.sort(symbols, function(a, b)
		local left, right = a.range.start, b.range.start
		if left.line == right.line then
			return left.character < right.character
		end
		return left.line < right.line
	end)
	local roots, stack = {}, {}
	for _, symbol in ipairs(symbols) do
		local first, last = symbol.range.start, symbol.range["end"]
		while #stack > 0 do
			local parent = stack[#stack].range
			local after_start = first.line > parent.start.line
				or (first.line == parent.start.line and first.character > parent.start.character)
			local before_end = last.line < parent["end"].line
				or (last.line == parent["end"].line and last.character <= parent["end"].character)
			if after_start and before_end then break end
			table.remove(stack)
		end
		local siblings = #stack > 0 and stack[#stack].children or roots
		siblings[#siblings + 1] = symbol
		stack[#stack + 1] = symbol
	end
	callback(roots, opts)
end

return M
