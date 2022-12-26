local icons = require("icons")
local mappings = require("mappings")

local M = {
	"folke/which-key.nvim",
	lazy = false,
}

local normal_mappings = {
	q = { "<cmd>bwipeout<cr>", "Close buffer" }, -- Shortcut
	Q = { "<cmd>tabclose<cr>", "Close tab" }, -- Shortcut

	b = {
		name = "Buffers",
		c = {
			name = "Close",
			a = { "<cmd>%bwipeout<cr>", "All" },
			c = { "<cmd>bwipeout<cr>", "Current" },
			o = { '<cmd>%bdelete | e # | normal `"<cr>', "Others" },
		},
		g = {
			name = "Group",
		},
		m = {
			name = "Move",
		},
		s = {
			name = "Sort",
		},
	},

	c = {
		name = "Code",
	},

	f = {
		name = "Find",
	},

	g = {
		name = "Git",
		b = {
			name = "Buffer",
		},
		l = {
			name = "List",
		},
	},

	i = {
		name = "Installer",
	},

	l = {
		name = "LaTeX",
	},

	n = {
		name = "Notebooks",
	},

	p = {
		name = "Projects",
	},

	T = {
		name = "Tests",
	},

	t = {
		name = "Terminal",
	},

	u = {
		name = "Utils",
	},
}

local visual_mappings = {
	n = {
		name = "Notebooks",
	},
	t = {
		name = "Terminal",
	},
}

function M.config()
	require("which-key").setup({
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			presets = {
				operators = true, -- adds help for operators like d, y, ...
				motions = true, -- adds help for motions
				text_objects = true, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
		},
		icons = {
			breadcrumb = icons.arrow.double_right_short, -- symbol used in the command line area that shows your active key combo
			separator = icons.arrow.right, -- symbol used between a key and it's label
			group = icons.folder.open .. icons.single_space, -- symbol prepended to a group
		},
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "center", -- align columns left, center or right
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
		show_help = true, -- show help message on the command line when the popup is visible
	})

	mappings.register_normal(normal_mappings)
	mappings.register_visual(visual_mappings)
end

return M
