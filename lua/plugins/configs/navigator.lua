local M = {
	"numToStr/Navigator.nvim",
	cmd = { "NavigatorLeft", "NavigatorRight", "NavigatorUp", "NavigatorDown" },
}

function M.init()
	vim.keymap.set({ "n", "t" }, "<C-h>", "<CMD>NavigatorLeft<CR>")
	vim.keymap.set({ "n", "t" }, "<C-l>", "<CMD>NavigatorRight<CR>")
	vim.keymap.set({ "n", "t" }, "<C-k>", "<CMD>NavigatorUp<CR>")
	vim.keymap.set({ "n", "t" }, "<C-j>", "<CMD>NavigatorDown<CR>")
end

function M.config()
	require("Navigator").setup()
end

return M
