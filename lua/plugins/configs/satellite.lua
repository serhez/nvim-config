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
		excluded_filetypes = {
			"neo-tree",
			"nvim-tree",
			"Outline",
			"Trouble",
			"lazy",
			"help",
			"spectre_panel",
			"toggleterm",
			"dapui_scopes",
			"dapui_breakpoints",
			"dapui_stacks",
			"dapui_watches",
			"dapui_console",
			"dapui_repl",
		},
		width = 1,
		handlers = {
			search = {
				enable = true,
			},
			diagnostic = {
				enable = true,
				signs = { icons.small_circle },
				min_severity = vim.diagnostic.severity.HINT,
			},
			gitsigns = {
				enable = true,
				signs = { -- can only be a single character (multibyte is okay)
					add = icons.bar.vertical_center_thin,
					change = icons.bar.vertical_center_thin,
					delete = icons.bar.lower_horizontal_thin,
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
