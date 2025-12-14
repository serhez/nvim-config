local M = {
	"saghen/blink.pairs",
	version = "*",
	dependencies = "saghen/blink.download",
	event = "VeryLazy",
}

function M.config()
	require("blink.pairs").setup({})
end

return M
