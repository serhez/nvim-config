local M = {
	"Julian/lean.nvim",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",

		-- optional dependencies:
		"Saghen/blink.cmp",
		"andymass/vim-matchup", -- for enhanced % motion behavior
		"andrewradev/switch.vim", -- for switch support
	},
	enabled = false, -- not using Lean ATM, but keeping the config for later
}

function M.config()
	require("lean").setup({
		-- TODO: create custom keymaps with which-key
		mappings = true,
	})
end

return M
