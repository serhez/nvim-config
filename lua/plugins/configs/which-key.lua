local M = {
	"folke/which-key.nvim",
	event = "VimEnter",
}

local function toggle_locationlist()
	local win = vim.api.nvim_get_current_win()
	local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
	local action = qf_winid > 0 and "lclose" or "lopen"
	vim.cmd(action)
end

local function toggle_quicklist()
	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
	local action = qf_winid > 0 and "cclose" or "copen"
	vim.cmd("botright " .. action)
end

local normal_mappings = {
	Q = { "<cmd>tabclose<cr>", "Close tab" }, -- Shortcut
	a = {
		name = "Assistant",
	},
	b = {
		name = "Buffers",
	},
	c = {
		name = "Code",
		d = {
			name = "Diagnostics",
		},
	},
	d = {
		name = "Debug",
		B = {
			name = "Breakpoints",
		},
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
		name = "List",
	},
	n = {
		name = "Notebooks",
	},
	p = {
		name = "Projects",
	},
	U = {
		name = "UI",
		l = { toggle_locationlist, "Location list" },
		m = { "<cmd>messages<cr>", "Messages" },
		q = { toggle_quicklist, "Quickfix list" },
		s = {
			name = "Split",
			h = { "<cmd>split<cr>", "Horizontal" },
			v = { "<cmd>vsplit<cr>", "Vertical" },
		},
		t = { "<cmd>tabnew<cr>", "New tab" },
	},
}

local visual_mappings = {
	a = {
		name = "Assistant",
	},
	n = {
		name = "Notebooks",
	},
	u = {
		name = "Utils",
	},
}

function M.config()
	local icons = require("icons")
	local mappings = require("mappings")

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
			group = icons.folder.open .. " ", -- symbol prepended to a group
		},
		window = {
			border = "none", -- none, single, double, shadow
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
		show_help = false, -- show help message on the command line when the popup is visible
	})

	mappings.register_normal(normal_mappings)
	mappings.register_visual(visual_mappings)

	local hls = require("highlights")
	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		WhichKeyFloat = { fg = c.statusline_fg, bg = c.statusline_bg },
		WhichKeyBorder = common_hls.no_border_statusline,
	})
end

return M
