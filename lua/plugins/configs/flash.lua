local M = {
	"folke/flash.nvim",
	event = "VeryLazy",
	keys = {
		{
			"f",
			mode = { "n", "o", "x" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"F",
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
	local flash = require("flash")
	flash.setup()

	vim.keymap.set({ "n", "x", "o" }, "f", function()
		flash.jump()
	end, { desc = "Jump to char" })
	vim.keymap.set({ "n", "x", "o" }, "F", function()
		flash.treesitter()
	end, { desc = "Treesitter selection" })
	vim.keymap.set({ "o" }, "r", function()
		flash.remote()
	end, { desc = "Remote" })
	vim.keymap.set({ "o", "x" }, "R", function()
		flash.treesitter_search()
	end, { desc = "Treesitter" })
	vim.keymap.set({ "c" }, "<c-s>", function()
		flash.toggle()
	end, { desc = "Toggle flash search" })
end

return M
