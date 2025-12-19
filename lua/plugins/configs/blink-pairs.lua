local M = {
	"saghen/blink.pairs",
	version = "*",
	dependencies = "saghen/blink.download",
	event = "VeryLazy",
}

function M.config()
	require("blink.pairs").setup({
		highlights = {
			groups = {
				"BlinkPairsDepth1",
				"BlinkPairsDepth2",
				"BlinkPairsDepth3",
				"BlinkPairsDepth4",
				"BlinkPairsDepth5",
				"BlinkPairsDepth6",
			},
		},
	})
end

return M
