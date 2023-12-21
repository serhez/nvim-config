local M = {
	"ghillb/cybu.nvim",
	branch = "main", -- timely updates
	dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" }, -- optional for icon support
	cmd = {
		"CybuNext",
		"CybuPrev",
		"CybuLastusedNext",
		"CybuLastusedPrev",
	},
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	-- vim.keymap.set("n", "<S-Tab>", "<cmd>CybuPrev<cr>")
	-- vim.keymap.set("n", "<Tab>", "<cmd>CybuNext<cr>")
	vim.keymap.set({ "n", "v" }, "<S-Backspace>", "<cmd>CybuLastusedPrev<cr>")
	vim.keymap.set({ "n", "v" }, "<Backspace>", "<cmd>CybuLastusedNext<cr>")
end

function M.config()
	local icons = require("icons")

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		CybuCurrentBuffer = { bg = c.cursor_line_bg, fg = c.title_fg, bold = true },
		CybuAdjacentBuffers = { bg = c.statusline_bg, fg = c.comment_fg },
		CybuBackground = { bg = c.statusline_bg, fg = c.statusline_bg },
		CybuBorder = { bg = c.statusline_bg, fg = c.statusline_bg },
	})

	require("cybu").setup({
		position = {
			relative_to = "editor", -- win, editor, cursor
			anchor = "center", -- topleft, topcenter, topright,
			-- centerleft, center, centerright,
			-- bottomleft, bottomcenter, bottomright
			vertical_offset = 0, -- vertical offset from anchor in lines
			horizontal_offset = 0, -- vertical offset from anchor in columns
			max_win_height = 5, -- height of cybu window in lines
			max_win_width = 0.5, -- integer for absolute in columns
			-- float for relative to win/editor width
		},
		style = {
			path = "tail", -- absolute, relative, tail (filename only)
			path_abbreviation = "none", -- none, shortened
			border = "double", -- single, double, rounded, none
			separator = " ", -- string used as separator
			prefix = icons.three_dots, -- string used as prefix for truncated paths
			padding = 3, -- left & right padding in number of spaces
			hide_buffer_id = true, -- hide buffer IDs in window
			devicons = {
				enabled = true, -- enable or disable web dev icons
				colored = true, -- enable color for web dev icons
				truncate = true, -- truncate wide icons to one char width
			},
			highlights = { -- see highlights via :highlight
				current_buffer = "CybuCurrentBuffer", -- current / selected buffer
				adjacent_buffers = "CybuAdjacentBuffers", -- buffers not in focus
				background = "CybuBackground", -- window background
				border = "CybuBorder", -- border of the window
			},
		},
		behavior = { -- set behavior for different modes
			mode = {
				default = {
					switch = "immediate", -- immediate, on_close
					view = "rolling", -- paging, rolling
				},
				last_used = {
					switch = "immediate", -- immediate, on_close
					view = "rolling", -- paging, rolling
				},
				auto = {
					view = "rolling", -- paging, rolling
				},
			},
			show_on_autocmd = false, -- event to trigger cybu (eg. "BufEnter")
		},
		display_time = 750, -- time the cybu window is displayed
		exclude = { -- filetypes, cybu will not be active
			"neo-tree",
			"fugitive",
			"qf",
		},
		filter = {
			unlisted = true, -- filter & fallback for unlisted buffers
		},
	})
end

return M
