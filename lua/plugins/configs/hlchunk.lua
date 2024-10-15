local M = {
	"shellRaining/hlchunk.nvim",
	event = "VeryLazy",
}

function M.config()
	local c = require("highlights").colors()
	local icons = require("icons")

	require("hlchunk").setup({
		chunk = {
			enable = true,
			priority = 2,
			use_treesitter = true,
			notify = true,
			chars = {
				horizontal_line = icons.bar.horizontal_thin,
				vertical_line = icons.bar.vertical_center_thin,
				left_top = icons.bar.upper_left_corner_thin,
				left_bottom = icons.bar.lower_left_corner_thin,
				right_arrow = icons.bar.horizontal_thin,
			},
			textobject = "ic",
			style = {
				{
					fg = c.info_fg, -- no error
				},
				{
					fg = c.error_fg, -- error
				},
			},
			-- FIX: The animation creates artifacts when moving the cursor fast
			-- duration = 200,
			-- delay = 1,
			duration = 0,
			delay = 0,
		},

		indent = {
			enable = true,
			priority = 1,
			use_treesitter = false,
			chars = {
				icons.bar.vertical_center_thin,
			},
			style = {
				{
					fg = c.comment_fg,
				},
			},
			delay = 0,
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

		exclude_filetypes = {
			qf = true,
			help = true,
			dapui_scopes = true,
			dapui_watches = true,
			dapui_stacks = true,
			dapui_breakpoints = true,
			dapui_console = true,
			["dap-repl"] = true,
			harpoon = true,
			dropbar_menu = true,
			glow = true,
			aerial = true,
			dashboard = true,
			lspinfo = true,
			lspsagafinder = true,
			packer = true,
			checkhealth = true,
			man = true,
			mason = true,
			NvimTree = true,
			["neo-tree"] = true,
			plugin = true,
			lazy = true,
			TelescopePrompt = true,
			[""] = true, -- because TelescopePrompt will set an empty ft, so add this.
			alpha = true,
			toggleterm = true,
			sagafinder = true,
			sagaoutline = true,
			better_term = true,
			fugitiveblame = true,
			Trouble = true,
			Outline = true,
			OutlineHelp = true,
			starter = true,
			NeogitPopup = true,
			NeogitStatus = true,
			DiffviewFiles = true,
			DiffviewFileHistory = true,
			DressingInput = true,
			spectre_panel = true,
			zsh = true,
			vuffers = true,
			oil = true,
			oil_preview = true,
			NeogitConsole = true,
			text = true,
			AvanteInput = true,
		},
	})
end

return M
