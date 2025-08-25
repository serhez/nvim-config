local M = {
	"karb94/neoscroll.nvim",
	event = "VeryLazy",
}

function M.config()
	require("neoscroll").setup({
		duration_multiplier = 0.5,
	})
end

return M
