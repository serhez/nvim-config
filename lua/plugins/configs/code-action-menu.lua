local mappings = require("mappings")

local M = {
	"weilbith/nvim-code-action-menu",
	event = "BufReadPost",
}

function M.init()
	mappings.register_normal({
		c = {
			a = { "<cmd>CodeActionMenu<cr>", "Action" },
		},
	})
end

return M
