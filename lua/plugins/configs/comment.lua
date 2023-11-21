local M = {
	"numToStr/Comment.nvim",
	event = "BufReadPre",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
}

function M.init()
	local mappings = require("mappings")

	mappings.register_normal({
		["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
	})
	mappings.register_visual({
		["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment" },
	})
end

function M.config()
	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end

return M
