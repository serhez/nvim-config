local mappings = require("mappings")

local M = {
	"weilbith/nvim-code-action-menu",
	event = "BufReadPost",
}

function M.init()
	mappings.register({ "<leader>ca", "<cmd>CodeActionMenu<cr>", desc = "Action" })
end

return M
