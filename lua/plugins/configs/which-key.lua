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

local group_mappings = {
	{ "<leader>a", group = "Assistant" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>c", group = "Code" },

	{ "<leader>d", group = "Debug" },
	{ "<leader>dB", group = "Breakpoints" },

	{ "<leader>g", group = "Git" },
	{ "<leader>gb", group = "Buffer" },
	{ "<leader>gl", group = "List" },

	{ "<leader>i", group = "Installer" },
	{ "<leader>l", group = "List" },
	{ "<leader>n", group = "Notebooks" },
	{ "<leader>p", group = "Projects" },

	{ "<leader>U", group = "UI" },
	{ "<leader>Us", group = "Split" },

	{ "<leader>a", group = "Assistant", mode = "v" },
	{ "<leader>n", group = "Notebooks", mode = "v" },
	{ "<leader>u", group = "Utils", mode = "v" },
}

function M.config()
	local icons = require("icons")

	require("which-key").setup({
		preset = "classic",
		icons = {
			breadcrumb = icons.arrow.double_right_short, -- symbol used in the command line area that shows your active key combo
			separator = icons.arrow.right, -- symbol used between a key and it's label
			group = icons.folder.open .. " ", -- symbol prepended to a group
		},
		win = {
			border = "none", -- none, single, double, shadow
			padding = { 2, 2 }, -- extra window padding [top, right, bottom, left]
		},
		show_help = false, -- show help message on the command line when the popup is visible
		show_keys = true, -- show the currently pressed key and its label as a message in the command line
	})

	require("mappings").register(group_mappings)

	local hls = require("highlights")
	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		WhichKeyNormal = { fg = c.statusline_fg, bg = c.statusline_bg },
		WhichKeyBorder = common_hls.no_border_statusline,
	})
end

return M
