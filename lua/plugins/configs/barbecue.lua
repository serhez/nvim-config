local icons = require("icons")

local M = {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	event = "BufReadPost",
	cond = not vim.g.started_by_firenvim,
}

function M.config()
	require("barbecue").setup({
		show_dirname = false,
		show_basename = true,
		show_modified = false,
		symbols = {
			---modification indicator
			---@type string
			modified = icons.small_circle,

			---truncation indicator
			---@type string
			ellipsis = icons.three_dots,

			---entry separator
			---@type string
			separator = icons.arrow.right_tall,
		},
	})
end

return M
