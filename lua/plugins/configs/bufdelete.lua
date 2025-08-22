local M = {
	"famiu/bufdelete.nvim",
	lazy = false,
}

function M.init()
	require("mappings").register({
		{ "<leader>bc", "<cmd>Bwipeout<cr>", desc = "Close current" },
		{ "<leader>ba", "<cmd>%Bwipeout<cr>", desc = "Close all" },
		{ "<leader>bo", '<cmd>%Bdelete | e # | normal `"<cr>', desc = "Close others" },
	})
end

return M
