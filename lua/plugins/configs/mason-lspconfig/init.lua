local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	event = "VeryLazy",
}

local function lspSymbol(name, icon)
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

local function custom_attach(_, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

-- local native_hover_handler = vim.lsp.with(vim.lsp.handlers.hover, {
-- 	border = "solid",
-- 	position = { row = 0, col = 0 },
-- 	silent = true,
-- })
--
-- local islist = vim.islist or vim.tbl_islist
--
-- local function hover_handler(_, result, ctx)
-- 	if result and result.contents then
-- 		if result.contents:sub(1, 3) == "```" then
-- 			result.contents = "ohh"
-- 		end
-- 		if result.contents:sub(-3, -1) == "```" then
-- 			result.contents = "ahh"
-- 		end
-- 	end
--
-- 	local contents = result.contents
--
-- 	if type(contents) ~= "table" or not islist(contents) then
-- 		contents = { contents }
-- 	end
--
-- 	local parts = {}
--
-- 	for _, content in ipairs(contents) do
-- 		if type(content) == "string" then
-- 			table.insert(parts, content)
-- 		elseif content.language then
-- 			table.insert(parts, ("```%s\n%s\n```"):format(content.language, content.value))
-- 		elseif content.kind == "markdown" then
-- 			table.insert(parts, content.value)
-- 		elseif content.kind == "plaintext" then
-- 			table.insert(parts, ("```\n%s\n```"):format(content.value))
-- 		elseif islist(content) then
-- 			vim.list_extend(parts, M.format_markdown(content))
-- 		end
-- 		-- ignore other types of content (invalid content)
-- 	end
--
-- 	return vim.split(table.concat(parts, "\n"), "\n")
--
-- 	-- native_hover_handler(_, result, ctx)
-- end

function M.config()
	local icons = require("icons")
	local lspconfig = require("lspconfig")

	require("mason-lspconfig").setup()

	local custom_capabilities = vim.lsp.protocol.make_client_capabilities()
	-- custom_capabilities.offsetEncoding = "utf-8"
	custom_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
	custom_capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
	custom_capabilities.textDocument.completion.completionItem.snippetSupport = true
	custom_capabilities.textDocument.completion.completionItem.preselectSupport = true
	custom_capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	custom_capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	custom_capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	custom_capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	custom_capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	custom_capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local opts = {
				on_attach = custom_attach,
				capabilities = custom_capabilities,
				flags = {
					debounce_text_changes = 150,
				},
			}

			local has_custom_opts, custom_opts =
				pcall(require, "plugins.configs.mason-lspconfig.servers." .. server_name)
			if has_custom_opts then
				-- Enhance the default opts with the server-specific ones
				opts.settings = custom_opts
			end

			lspconfig[server_name].setup(opts)
			vim.cmd([[ do User LspAttachBuffers ]])
		end,
	})

	-- Configure Dart/Flutter server here since it is not installed via Mason
	lspconfig.dartls.setup({
		cmd = { "dart", "language-server", "--protocol=lsp" },
		filetypes = { "dart" },
		init_options = {
			closingLabels = true,
			flutterOutline = true,
			onlyAnalyzeProjectsWithOpenFiles = true,
			outline = true,
			suggestFromUnimportedLibraries = true,
		},
		-- root_dir = root_pattern("pubspec.yaml"),
		settings = {
			dart = {
				completeFunctionCalls = true,
				showTodos = true,
			},
		},
		on_attach = custom_attach,
	})

	-- Configure Swift server here since it is not installed via Mason
	local sourcekit_opts = {
		on_attach = custom_attach,
		capabilities = vim.tbl_deep_extend("force", custom_capabilities, {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		}),
		flags = {
			debounce_text_changes = 150,
		},
	}
	local has_custom_opts, custom_opts = pcall(require, "plugins.configs.mason-lspconfig.servers.sourcekit")
	if has_custom_opts then
		-- Enhance the default opts with the server-specific ones
		sourcekit_opts.settings = custom_opts
	end
	lspconfig.sourcekit.setup(sourcekit_opts)

	-- Diagnostics
	lspSymbol("Error", icons.diagnostics.error)
	lspSymbol("Info", icons.diagnostics.info)
	lspSymbol("Hint", icons.diagnostics.hint)
	lspSymbol("Warn", icons.diagnostics.warning)

	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		underline = {
			severity = vim.diagnostic.severity.WARN,
		},
		float = {
			focusable = false,
			border = "none",
			source = false,
			header = "",
			prefix = "",
			suffix = "",
			format = function(d)
				local str = "  "
				if d.severity == vim.diagnostic.severity.ERROR then
					str = str .. icons.diagnostics.error .. " "
				elseif d.severity == vim.diagnostic.severity.WARN then
					str = str .. icons.diagnostics.warning .. " "
				elseif d.severity == vim.diagnostic.severity.INFO then
					str = str .. icons.diagnostics.info .. " "
				elseif d.severity == vim.diagnostic.severity.HINT then
					str = str .. icons.diagnostics.hint .. " "
				end
				return str .. d.message .. "  "
			end,
		},
		-- float = false,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Hovers
	-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	-- 	border = "solid",
	-- 	position = { row = 0, col = 0 },
	-- 	silent = true,
	-- })
	-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	-- 	border = "none",
	-- 	position = { row = 0, col = 0 },
	-- })

	-- Save after renaming
	local rename_handler = vim.lsp.handlers["textDocument/rename"]
	vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
		rename_handler(err, result, ctx, config)

		if err or not result then
			return
		end

		local function write_buf(buf)
			if buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd("w")
				end)
			end
		end
		if result.changes then
			for uri, _ in pairs(result.changes) do
				local buf = vim.uri_to_bufnr(uri)
				write_buf(buf)
			end
		elseif result.documentChanges then
			for _, change in ipairs(result.documentChanges) do
				local buf = vim.uri_to_bufnr(change.textDocument.uri)
				write_buf(buf)
			end
		end
	end

	-- Start the servers and attach them to buffers, since we are lazy loading
	vim.cmd("LspStart")

	-- -- Custom namespace
	-- local ns = vim.api.nvim_create_namespace("severe-diagnostics")
	--
	-- -- Reference to the original handler
	-- local orig_signs_handler = vim.diagnostic.handlers.signs

	-- -- Overriden diagnostics signs helper to only show the single most relevant sign
	-- ---@see `:h diagnostic-handlers`
	-- vim.diagnostic.handlers.signs = {
	-- 	show = function(_, bufnr, _, opts)
	-- 		-- get all diagnostics from the whole buffer rather
	-- 		-- than just the diagnostics passed to the handler
	-- 		local diagnostics = vim.diagnostic.get(bufnr)
	--
	-- 		local filtered_diagnostics = filter_diagnostics(diagnostics)
	--
	-- 		-- pass the filtered diagnostics (with the
	-- 		-- custom namespace) to the original handler
	-- 		orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
	-- 	end,
	--
	-- 	hide = function(_, bufnr)
	-- 		orig_signs_handler.hide(ns, bufnr)
	-- 	end,
	-- }
end

return M
