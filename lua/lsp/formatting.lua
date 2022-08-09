local M = {}

-- Formatting

M.augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local auto_format_enabled = true -- Default

function M.toggle_auto_format()
	auto_format_enabled = not auto_format_enabled
end

-- TODO: When nvim 0.8 arrives, a new API for formatting will be available and you will be able to set it up as https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
-- NOTE: formatting_seq_sync() sequentially picks an LSP server to do formatting; it choses in the following order:
-- NOTE:    1. Servers that are not listed on the given list (so don't list the servers you want to do the formatting).
-- NOTE:    2. Servers that are on the list, in the order they appear there.
function M.format()
	vim.lsp.buf.formatting_seq_sync({}, 5000, {
		"gopls",
		"clangd",
		"jsonls",
		"sumneko_lua",
		"eslint_d",
		"eslint",
		"html",
		"cssls",
		"cmake",
		"pyright",
		"tailwindcss",
		"volar",
		"yamlls",
		"zeta_note",
		"vimls",
		"texlab",
		"lemminx",
		"dotls",
	})
end

function M.auto_format()
	if auto_format_enabled then
		M.format()
	end
end

return M
