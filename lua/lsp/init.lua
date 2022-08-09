local icons = require("icons")
local formatting = require("lsp.formatting")

local M = {}

local function lspSymbol(name, icon)
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

-- LSP general config
function M.setup()
	lspSymbol("Error", icons.diagnostics.error)
	lspSymbol("Info", icons.diagnostics.info)
	lspSymbol("Hint", icons.diagnostics.hint)
	lspSymbol("Warn", icons.diagnostics.warning)

	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		underline = true,
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
end

-- Configure and startup servers

local function custom_attach(client, bufnr)
	require("illuminate").on_attach(client)

	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Auto-format on save
	-- FIX: The if statement yields false for .ts files
	-- if client.supports_method("textDocument/formatting") then
	vim.api.nvim_clear_autocmds({ group = formatting.augroup, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = formatting.augroup,
		buffer = bufnr,
		callback = function()
			formatting.auto_format()
		end,
	})
	-- end

	-- Mappings (some are commented as they are currently handled by plugins)
	vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = false, silent = true })
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
	["eslint_d"] = require("lsp.servers.eslint_d"),
	["sumneko_lua"] = require("lsp.servers.sumneko_lua"),
	["volar"] = require("lsp.servers.volar"),
}

require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({})
	end,
})
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

return M
