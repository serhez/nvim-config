local M = {
	"vidocqh/auto-indent.nvim",
	event = "InsertEnter",
}

function M.config()
	require("auto-indent").setup({})
end

return M
