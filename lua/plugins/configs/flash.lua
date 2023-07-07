local M = {
	"folke/flash.nvim",
	event = "VeryLazy",
	keys = {
		{
			"m",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"M",
			mode = { "n", "o", "x" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Flash treesitter search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle flash search",
		},
	},
}

function M.config()
	require("flash").setup()
end

return M
