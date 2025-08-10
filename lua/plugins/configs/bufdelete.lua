local M = {
	"famiu/bufdelete.nvim",
	lazy = false,
}

function M.init()
	require("mappings").register({
		{ "q", "<cmd>Bwipeout<cr>", desc = "Quit buffer" },

		{ "<leader>bc", group = "Close" },
		{ "<leader>bca", "<cmd>%Bwipeout<cr>", desc = "All" },
		{ "<leader>bcc", "<cmd>Bwipeout<cr>", desc = "Current" },
		{ "<leader>bco", '<cmd>%Bdelete | e # | normal `"<cr>', desc = "Others" },
	})
end

return M
