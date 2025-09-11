local M = {
	"nvim-zh/colorful-winsep.nvim",
	event = "WinNew",
}

function M.config()
	require("colorful-winsep").setup({
		animate = {
			enabled = false, -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
		},
	})
end

return M
