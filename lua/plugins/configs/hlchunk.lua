local M = {
	"shellRaining/hlchunk.nvim",
	event = "BufReadPre",
}

function M.config()
	local c = require("highlights").colors()
	local icons = require("icons")

	require("hlchunk").setup({
		chunk = {
			enable = true,
			use_treesitter = true,
			notify = true,
			chars = {
				horizontal_line = icons.bar.horizontal_thin,
				vertical_line = icons.bar.vertical_center_thin,
				left_top = icons.bar.upper_left_corner_thin,
				left_bottom = icons.bar.lower_left_corner_thin,
				right_arrow = icons.bar.horizontal_thin,
			},
			style = {
				{
					fg = c.info_fg,
				},
			},
			exclude_filetypes = {
				qf = true,
				help = true,
				dapui_scopes = true,
				dapui_watches = true,
				dapui_stacks = true,
				dapui_breakpoints = true,
				dapui_console = true,
				["dap-repl"] = true,
			},
		},

		indent = {
			enable = true,
			use_treesitter = false,
			chars = {
				icons.bar.vertical_center_thin,
			},
			style = {
				{
					fg = c.comment_fg,
				},
			},
		},

		line_num = {
			enable = false,
		},

		blank = {
			enable = false,
			chars = {
				" ",
			},
			style = {
				{
					bg = c.bg,
				},
				{
					bg = c.cursor_line_bg,
				},
			},
		},
	})
end

return M
