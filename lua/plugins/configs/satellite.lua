local M = {
	"lewis6991/satellite.nvim",
	event = "BufRead",
}

function M.config()
	local icons = require("icons")

	require("satellite").setup({
		current_only = true,
		winblend = 50,
		zindex = 40,
		excluded_filetypes = {},
		width = 2,
		handlers = {
			search = {
				enable = true,
			},
			diagnostic = {
				enable = true,
				signs = { icons.rhombus },
				min_severity = vim.diagnostic.severity.HINT,
			},
			gitsigns = {
				enable = true,
				signs = { -- can only be a single character (multibyte is okay)
					add = icons.bar.vertical_center,
					change = icons.bar.vertical_center,
					delete = icons.bar.lower_horizontal,
				},
			},
			marks = {
				enable = true,
				show_builtins = false, -- shows the builtin marks like [ ] < >
			},
		},
	})
end

return M
