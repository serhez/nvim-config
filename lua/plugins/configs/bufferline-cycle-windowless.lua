local M = {
	"roobert/bufferline-cycle-windowless.nvim",
	dependencies = {
		"akinsho/bufferline.nvim",
	},
}

function M.init()
	vim.keymap.set("n", "<TAB>", "<cmd>BufferLineCycleWindowlessNext<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<S-TAB>", "<cmd>BufferLineCycleWindowlessPrev<cr>", { noremap = true, silent = true })
end

function M.config()
	require("bufferline-cycle-windowless").setup({
		-- whether to start in enabled or disabled mode
		default_enabled = true,
	})
end

return M
