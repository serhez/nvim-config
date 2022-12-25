local M = {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
}

function M.config()
	require("tmux").setup({
		copy_sync = {
			-- enables copy sync and overwrites all register actions to
			-- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
			enable = true,

			-- TMUX >= 3.2: yanks (and deletes) will get redirected to system
			-- clipboard by tmux
			redirect_to_clipboard = true,
		},
		navigation = {
			-- enables default keybindings (C-hjkl) for normal mode
			enable_default_keybindings = true,
		},
		resize = {
			-- enables default keybindings (A-hjkl) for normal mode
			enable_default_keybindings = true,
		},
	})
end

return M
