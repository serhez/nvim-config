local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPost",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		g = {
			a = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Author" },
			R = { "<cmd>Gitsigns reset_buffer<cr>", "Revert buffer" },
			h = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
			r = { "<cmd>Gitsigns reset_hunk<cr>", "Revert hunk" },
		},
	})

	vim.api.nvim_set_keymap("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { noremap = true, silent = true })
end

function M.config()
	local icons = require("icons")
	require("gitsigns").setup({
		signs = {
			add = {
				hl = "GitSignsAdd",
				text = icons.bar.vertical_center,
				numhl = "GitSignsAddNr",
				linehl = "GitSignsAddLn",
			},
			change = {
				hl = "GitSignsChange",
				text = icons.bar.vertical_center,
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			delete = {
				hl = "GitSignsDelete",
				text = icons.bar.lower_horizontal,
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			topdelete = {
				hl = "GitSignsDelete",
				text = icons.bar.lower_horizontal,
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = icons.bar.vertical_center,
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			untracked = {
				hl = "GitSignsAdd",
				text = icons.bar.vertical_center,
				numhl = "GitSignsAddNr",
				linehl = "GitSignsAddLn",
			},
		},
		numhl = false,
		linehl = false,
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
