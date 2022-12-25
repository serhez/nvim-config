local M = {
	"Jorengarenar/vim-MvVis",
	event = "CursorMoved",
}

function M.init()
	vim.api.nvim_set_keymap("v", "H", "<Plug>(MvVisLeft)", { silent = true })
	vim.api.nvim_set_keymap("v", "J", "<Plug>(MvVisDown)", { silent = true })
	vim.api.nvim_set_keymap("v", "K", "<Plug>(MvVisUp)", { silent = true })
	vim.api.nvim_set_keymap("v", "L", "<Plug>(MvVisRight)", { silent = true })
end

return M
