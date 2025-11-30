local M = {
	"numToStr/Navigator.nvim",
	cmd = { "NavigatorLeft", "NavigatorRight", "NavigatorUp", "NavigatorDown" },
}

function M.init()
	vim.keymap.set({ "n", "t", "i" }, "<M-j>", "<CMD>NavigatorLeft<CR>")
	vim.keymap.set({ "n", "t", "i" }, "<M-k>", "<CMD>NavigatorDown<CR>")
	vim.keymap.set({ "n", "t", "i" }, "<M-l>", "<CMD>NavigatorUp<CR>")

	-- Custom OS remap CMD+; to CMD+h, since CMD+; is not captured by terminal
	vim.keymap.set({ "n", "t", "i" }, "<M-h>", "<CMD>NavigatorRight<CR>")
end

function M.config()
	require("Navigator").setup()
end

return M
