local M = {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
}

function M.config()
	local icons = require("icons")

	require("fff").setup({
		prompt = icons.arrow.right_short_thick .. " ",
		title = "Files", -- Window title
		max_results = 100, -- Maximum search results to display
		max_threads = 4, -- Maximum threads for fuzzy search

		layout = {
			height = 0.8,
			width = 1.0,
			prompt_position = "bottom", -- or 'top'
			preview_position = "right", -- or 'left', 'right', 'top', 'bottom'
			preview_size = 0.6,
		},

		keymaps = {
			close = "<Esc>",
			select = "<CR>",
			select_split = "<C-|>",
			select_vsplit = "<C-_>",
			select_tab = "<C-t>",
			move_up = { "<Up>", "<C-k>" },
			move_down = { "<Down>", "<C-j>" },
			preview_scroll_up = "<C-u>",
			preview_scroll_down = "<C-d>",
		},
	})
end

return M
