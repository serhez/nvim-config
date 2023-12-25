local M = {
	"soulis-1256/hoverhints.nvim",
	event = "BufReadPost",
	enabled = false,
}

function M.config()
	require("hoverhints").setup({
		max_width_factor = 0.7,
		border = "solid",
	})
end

return M
