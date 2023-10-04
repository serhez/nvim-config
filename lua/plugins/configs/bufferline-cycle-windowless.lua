local M = {
	"roobert/bufferline-cycle-windowless.nvim",
	dependencies = {
		"akinsho/bufferline.nvim",
	},
}

function M.init()
	vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>BufferLineCycleWindowlessNext<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<S-TAB>", "<cmd>BufferLineCycleWindowlessPrev<cr>", { noremap = true, silent = true })
end

function M.config()
	require("bufferline-cycle-windowless").setup({
		-- whether to start in enabled or disabled mode
		default_enabled = true,
	})
end

return M
