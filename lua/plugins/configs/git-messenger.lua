local M = {
	"rhysd/git-messenger.vim",
	cmd = "GitMessenger",
}

function M.init()
	require("mappings").register({ "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Last commit message" })
end

function M.config()
	vim.g.git_messenger_no_default_mappings = true
	vim.g.git_messenger_always_into_popup = true
	vim.g.git_messenger_into_popup_after_show = false
	vim.g.git_messenger_floating_win_opts = { border = "none" }
end

return M
