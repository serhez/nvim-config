local M = {
	"EdenEast/nightfox.nvim",
}

function M.config()
	require("nightfox").setup({
		options = {
			styles = {
				comments = "italic",
				keywords = "bold",
				types = "italic,bold",
			},
		},
	})
end

return M
