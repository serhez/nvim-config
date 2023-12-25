local M = {
	"lewis6991/hover.nvim",
	event = "BufReadPre",
}

function M.config()
	require("hover").setup({
		init = function()
			-- Require providers
			require("hover.providers.lsp")
			require("hover.providers.gh")
			require("hover.providers.gh_user")
			-- require('hover.providers.jira')
			require("hover.providers.man")
			require("hover.providers.dictionary")
		end,
		preview_opts = {
			border = "none",
		},
		-- Whether the contents of a currently open hover window should be moved
		-- to a :h preview-window when pressing the hover keymap.
		preview_window = true,
		title = false,
		mouse_providers = {
			"LSP",
		},
		mouse_delay = 1000,
	})

	-- Setup keymaps
	vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
	vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })

	-- Mouse support
	vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
end

return M
