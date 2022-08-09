vim.g.loaded_matchit = 1
vim.g.matchup_matchparen_offscreen = { method = "status_manual" }

require("nvim-treesitter.configs").setup({
	matchup = {
		enable = true,
	},
})
