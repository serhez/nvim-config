local icons = require("icons")
local formatting = require("plugins.configs.mason-lspconfig.formatting")

local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	event = "BufReadPre",
}

local function lspSymbol(name, icon)
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

---Filters diagnostigs leaving only the most severe per line.
---@param diagnostics table[]
---@return table[]
---@see https://www.reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a/gvd8rb9/
---@see https://github.com/neovim/neovim/issues/15770
---@see https://github.com/akinsho/dotfiles/blob/d3526289627b72e4b6a3ddcbfe0411b5217a4a88/.config/nvim/plugin/lsp.lua#L83-L132
---@see `:h diagnostic-handlers`
local function filter_diagnostics(diagnostics)
	if not diagnostics then
		return {}
	end

	-- find the "worst" diagnostic per line
	local most_severe = {}
	for _, cur in pairs(diagnostics) do
		local max = most_severe[cur.lnum]

		-- higher severity has lower value (`:h diagnostic-severity`)
		if not max or cur.severity < max.severity then
			most_severe[cur.lnum] = cur
		end
	end

	-- return list of diagnostics
	return vim.tbl_values(most_severe)
end

local function custom_attach(client, bufnr)
	local present, navic = pcall(require, "nvim-navic")
	if present and client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Auto-format on save
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = formatting.augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = formatting.augroup,
			buffer = bufnr,
			callback = function()
				formatting.auto_format(bufnr)
			end,
		})
	end
end

local custom_capabilities = vim.lsp.protocol.make_client_capabilities()
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

-- Provide custom settings that should only apply to the following servers
local enhance_server_opts = {
	["eslint_d"] = require("plugins.configs.mason-lspconfig.servers.eslint_d"),
	["sumneko_lua"] = require("plugins.configs.mason-lspconfig.servers.sumneko_lua"),
	["volar"] = require("plugins.configs.mason-lspconfig.servers.volar"),
}

function M.config()
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
			show_header = true,
			source = true,
			border = "single",
			focusable = false,
		},
		update_in_insert = false,
		severity_sort = true,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	})

	-- Suppress error messages from lang servers
	vim.notify = function(msg, log_level)
		if msg:match("exit code") then
			return
		end
		if log_level == vim.log.levels.ERROR then
			vim.api.nvim_err_writeln(msg)
		else
			vim.api.nvim_echo({ { msg } }, true, {})
		end
	end

	require("mason-lspconfig").setup()

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local opts = {
				on_attach = custom_attach,
				capabilities = custom_capabilities,
				flags = {
					debounce_text_changes = 150,
				},
			}

			if enhance_server_opts[server_name] then
				-- Enhance the default opts with the server-specific ones
				opts.settings = enhance_server_opts[server_name]
			end

			require("lspconfig")[server_name].setup(opts)
			vim.cmd([[ do User LspAttachBuffers ]])
		end,
	})

	-- Sign column

	-- Custom namespace
	local ns = vim.api.nvim_create_namespace("severe-diagnostics")

	-- Reference to the original handler
	local orig_signs_handler = vim.diagnostic.handlers.signs

	-- Overriden diagnostics signs helper to only show the single most relevant sign
	---@see `:h diagnostic-handlers`
	vim.diagnostic.handlers.signs = {
		show = function(_, bufnr, _, opts)
			-- get all diagnostics from the whole buffer rather
			-- than just the diagnostics passed to the handler
			local diagnostics = vim.diagnostic.get(bufnr)

			local filtered_diagnostics = filter_diagnostics(diagnostics)

			-- pass the filtered diagnostics (with the
			-- custom namespace) to the original handler
			orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
		end,

		hide = function(_, bufnr)
			orig_signs_handler.hide(ns, bufnr)
		end,
	}
end

return M
