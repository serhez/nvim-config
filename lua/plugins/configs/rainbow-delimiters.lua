local M = {
	"HiPhish/rainbow-delimiters.nvim",
	event = "BufReadPre",
}

function M.config()
	vim.g.rainbow_delimiters = {
		query = {
			javascript = "rainbow-parens",
			tsx = "rainbow-parens",
		},
	}
end

return M
