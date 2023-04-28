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
		attach_navic = false, -- we attach navic in its own config, which allows us to priotitize servers
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

		kinds = {
			File = icons.file.empty,
			Module = icons.braces,
			Namespace = icons.braces,
			Package = icons.box,
			Class = icons.small_parent_tree,
			Method = icons.cube,
			Property = icons.tool,
			Field = icons.bracketed_prism,
			Constructor = icons.cube,
			Enum = icons.symmetrical_comms,
			Interface = icons.circle_conn,
			Function = icons.func,
			Variable = icons.prism,
			Constant = icons.communicator,
			String = icons.boxed_abc,
			Number = icons.tic_tac_toe,
			Boolean = icons.both_ways,
			Array = icons.brackets,
			Object = icons.braces,
			Key = icons.abc,
			Null = icons.both_ways,
			EnumMember = icons.asymmetrical_comms,
			Struct = icons.big_parent_tree,
			Event = icons.lightning,
			Operator = icons.math_ops,
			TypeParameter = icons.quoted_letter,
		},
	})
end

return M
