local M = {
	"lukas-reineke/headlines.nvim",
	ft = { "markdown", "quarto", "rmd" },
}

function M.config()
	require("headlines").setup()
end

return M
