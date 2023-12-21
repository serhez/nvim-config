local M = {
	"nvim-telescope/telescope-fzf-native.nvim",
	requires = "nvim-telescope/telescope.nvim",
	build = "make",
	cond = not vim.g.started_by_firenvim,
}

function M.config()
	require("telescope").load_extension("fzf")
end

return M
