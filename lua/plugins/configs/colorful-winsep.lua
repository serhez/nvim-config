local M = {
	"nvim-zh/colorful-winsep.nvim",
	event = { "WinNew" },
}

function M.config()
	require("colorful-winsep").setup()
end

return M
