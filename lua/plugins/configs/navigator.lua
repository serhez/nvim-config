local M = {
	"numToStr/Navigator.nvim",
	cmd = { "NavigatorLeft", "NavigatorRight", "NavigatorUp", "NavigatorDown" },
	-- enabled = false,
}

function M.init()
	vim.keymap.set({ "n", "t" }, "<M-h>", "<CMD>NavigatorLeft<CR>")
	vim.keymap.set({ "n", "t" }, "<M-l>", "<CMD>NavigatorRight<CR>")
	vim.keymap.set({ "n", "t" }, "<M-k>", "<CMD>NavigatorUp<CR>")
	vim.keymap.set({ "n", "t" }, "<M-j>", "<CMD>NavigatorDown<CR>")
end

function M.config()
	require("Navigator").setup()
end

return M
