local mappings = require("mappings")

local M = {
	"numToStr/Comment.nvim",
	event = "BufReadPre",
}

function M.init()
	mappings.register_normal({
		["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
	})
	mappings.register_visual({
		["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment" },
	})
end

function M.config()
	require("Comment").setup()
end

return M