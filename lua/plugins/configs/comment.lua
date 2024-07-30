local M = {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
}

function M.init()
	require("mappings").register({
		{ "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment" },
		{ "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment", mode = "v" },
	})
end

function M.config()
	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end

return M
