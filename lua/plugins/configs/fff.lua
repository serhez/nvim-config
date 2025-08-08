local M = {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
}

function M.init()
	require("mappings").register({
		{
			"<leader>f",
			function()
				-- or find_in_git_root() if you only want git files
				require("fff").find_files()
			end,
			desc = "Find files",
		},
	})
end

function M.config()
	local icons = require("icons")

	require("fff").setup({
		width = 1.0, -- Window width as fraction of screen
		height = 0.8, -- Window height as fraction of screen
		prompt = icons.arrow.right_short_thick .. " ",
		preview = {
			enabled = true,
			width = 0.6,
		},
		title = "Files", -- Window title
		max_results = 60, -- Maximum search results to display
		max_threads = 4, -- Maximum threads for fuzzy search

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
