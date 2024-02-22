local M = {
	"vidocqh/auto-indent.nvim",
	event = "InsertEnter",
	enabled = false,
}

function M.config()
	require("auto-indent").setup()
end

return M
