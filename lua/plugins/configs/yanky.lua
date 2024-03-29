local M = {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
}

function M.init()
	local mappings = require("mappings")

	vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
	vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
	vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
	vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
	vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
	vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
	vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

	mappings.register_normal({
		F = {
			y = { "<cmd>Telescope yank_history theme=ivy<cr>", "Yank history" },
		},
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
