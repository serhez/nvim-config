local M = {
	"swaits/zellij-nav.nvim",
	enabled = false,
}

function M.init()
	vim.keymap.set({ "n", "t" }, "<C-h>", require("zellij-nav").left)
	vim.keymap.set({ "n", "t" }, "<C-l>", require("zellij-nav").right)
	vim.keymap.set({ "n", "t" }, "<C-k>", require("zellij-nav").up)
	vim.keymap.set({ "n", "t" }, "<C-j>", require("zellij-nav").down)

	-- NOTE: Ensures that when exiting NeoVim, Zellij returns to normal mode
	vim.api.nvim_create_autocmd("VimLeave", {
		pattern = "*",
		command = "silent !zellij action switch-mode normal",
	})
end

return M
