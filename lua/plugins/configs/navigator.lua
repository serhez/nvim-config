local M = {
	"numToStr/Navigator.nvim",
	cmd = { "NavigatorLeft", "NavigatorRight", "NavigatorUp", "NavigatorDown" },
}

function M.init()
	vim.keymap.set({ "n", "t", "i" }, "<M-h>", "<CMD>NavigatorLeft<CR>")
	vim.keymap.set({ "n", "t", "i" }, "<M-l>", "<CMD>NavigatorRight<CR>")
	vim.keymap.set({ "n", "t", "i" }, "<M-k>", "<CMD>NavigatorUp<CR>")
	vim.keymap.set({ "n", "t", "i" }, "<M-j>", "<CMD>NavigatorDown<CR>")
end

function M.config()
	require("Navigator").setup()
end

return M
