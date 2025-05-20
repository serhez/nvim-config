local M = {
	"zeioth/garbage-day.nvim",
	dependencies = "neovim/nvim-lspconfig",
	event = "VeryLazy",
	opts = {
		aggressive_mode = false, -- stop all lsp clients except the current buffer, every time you enter a buffer
		grace_period = 60 * 5, -- seconds, i.e., 5 minutes
		excluded_lsp_clients = {
			"null-ls",
			"jdtls",
			"marksman",
			"lua_ls",
			"copilot",
			"copilot_ls",
		},
	},
}

return M
