local M = {
	"HiPhish/rainbow-delimiters.nvim",
	lazy = false,
	enabled = false,
}

function M.config()
	require("rainbow-delimiters.setup").setup({
		query = {
			javascript = "rainbow-parens",
			tsx = "rainbow-parens",
		},
		priority = {
			[""] = 100,
		},
	})
end

return M
