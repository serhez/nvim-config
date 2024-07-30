local M = {
	"weilbith/nvim-code-action-menu",
	cmd = "CodeActionMenu",
}

function M.init()
	require("mappings").register({ "<leader>ca", "<cmd>CodeActionMenu<cr>", desc = "Action" })
end

return M
