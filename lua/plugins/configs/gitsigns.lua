local mappings = require("mappings")

local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
}

function M.init()
	mappings.register_normal({
		g = {
			a = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Author" },
			b = {
				r = { "<cmd>Gitsigns reset_buffer<cr>", "Revert" },
			},
			h = {
				name = "Hunk",
				j = { "<cmd>Gitsigns next_hunk<cr>", "Next" },
				k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev" },
				p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview" },
				r = { "<cmd>Gitsigns reset_hunk<cr>", "Revert" },
			},
		},
	})
end

function M.config()
	require("gitsigns").setup({
		signs = {
			add = {
				hl = "GitSignsAdd",
				text = "▎",
				numhl = "GitSignsAddNr",
				linehl = "GitSignsAddLn",
			},
			change = {
				hl = "GitSignsChange",
				text = "▎",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			delete = {
				hl = "GitSignsDelete",
				text = "契",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			topdelete = {
				hl = "GitSignsDelete",
				text = "契",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "▎",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		numhl = false,
		linehl = false,
		keymaps = {
			-- Default keymap options
			noremap = true,
			buffer = true,
		},
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
		},
		sign_priority = 100,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		word_diff = false,
		diff_opts = {
			internal = true,
		},
	})
end

return M
