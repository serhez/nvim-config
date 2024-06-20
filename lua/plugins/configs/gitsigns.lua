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
				text = icons.bar.vertical_center,
			},
			change = {
				text = icons.bar.vertical_center,
			},
			delete = {
				text = icons.bar.lower_horizontal,
			},
			topdelete = {
				text = icons.bar.lower_horizontal,
			},
			changedelete = {
				text = icons.bar.vertical_center,
			},
			untracked = {
				text = icons.bar.vertical_center,
			},
		},
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			ignore_whitespace = true,
			delay = 500,
		},
		sign_priority = 100,
		status_formatter = nil, -- Use default
		max_file_length = 10000,
		preview_config = {
			-- Options passed to nvim_open_win
			border = "solid",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
end

return M
