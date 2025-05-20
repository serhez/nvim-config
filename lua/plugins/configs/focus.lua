local M = {
	"nvim-focus/focus.nvim",
	version = "*",
	event = "BufEnter",
	enabled = false, -- NOTE: the colorschemes bug when using this plugin
}

function M.init()
	require("mappings").register({
		{ "<leader>uS", group = "Split" },

		{ "_", "<cmd>FocusSplitDown<cr>", desc = "Horizontal split" },
		{ "|", "<cmd>FocusSplitRight<cr>", desc = "Vertical split" },
		{ "<leader>uSj", "<cmd>FocusSplitDown<cr>", desc = "Down" },
		{ "<leader>uSl", "<cmd>FocusSplitRight<cr>", desc = "Right" },
		{ "<leader>uSh", "<cmd>FocusSplitLeft<cr>", desc = "Left" },
		{ "<leader>uSk", "<cmd>FocusSplitUp<cr>", desc = "Up" },
		{ "<leader>us", "<cmd>FocusSplitNicely<cr>", desc = "Automatic split" },
		{ "<leader>ue", "<cmd>FocusEqualise<cr>", desc = "Equalize window sizes" },
		{ "<leader>ua", "<cmd>FocusToggle<cr>", desc = "Toggle automatic window resizing" },
		{ "<leader>uz", "<cmd>FocusMaximise<cr>", desc = "Zoom window" },
	})
end

function M.config()
	require("focus").setup({
		split = {
			bufnew = true, -- Create blank buffer for new split windows
			tmux = false, -- Create tmux splits instead of neovim splits
		},
		ui = {
			number = false, -- Display line numbers in the focussed window only
			relativenumber = false, -- Display relative line numbers in the focussed window only
			hybridnumber = false, -- Display hybrid line numbers in the focussed window only
			absolutenumber_unfocussed = true, -- Preserve absolute numbers in the unfocussed windows

			cursorline = false, -- Display a cursorline in the focussed window only
			cursorcolumn = false, -- Display cursorcolumn in the focussed window only
			colorcolumn = {
				enable = false, -- Display colorcolumn in the foccused window only
				list = "+1", -- Set the comma-saperated list for the colorcolumn
			},
			signcolumn = true, -- Display signcolumn in the focussed window only
			winhighlight = true, -- Auto highlighting for focussed/unfocussed windows
		},
	})
end

return M
