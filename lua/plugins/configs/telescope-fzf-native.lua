local M = {
	"nvim-telescope/telescope-fzf-native.nvim",
	build = "make",
	cond = not vim.g.started_by_firenvim,
}

return M
