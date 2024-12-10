local M = {
	"supermaven-inc/supermaven-nvim",
	event = "InsertEnter",
	enabled = false,
}

function M.config()
	require("supermaven-nvim").setup({
		keymaps = {
			accept_suggestion = "<D-l>",
			clear_suggestion = "<D-h>",
			accept_word = "<D-w>",
		},
	})
end

return M
