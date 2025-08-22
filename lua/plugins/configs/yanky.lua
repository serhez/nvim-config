local M = {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
}

function M.init()
	vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
	vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
	vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
	vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
	vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
	vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
	vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

	require("mappings").register({
		{ "<leader>y", "<cmd>YankyRingHistory<cr>", desc = "Yank history", mode = { "n", "x" } },
	})
end

function M.config()
	require("yanky").setup({
		highlight = {
			timer = 200,
		},
	})

	local hls = require("highlights")
	hls.register_hls({
		YankyPut = { default = true, link = "Search" },
	})
end

return M
