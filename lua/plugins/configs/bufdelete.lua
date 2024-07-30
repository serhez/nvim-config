local mappings = require("mappings")

local M = {
	"famiu/bufdelete.nvim",
	event = "BufReadPost",
}

function M.init()
	mappings.register({
		{ "<leader>q", "<cmd>Bwipeout<cr>", desc = "Quit buffer" }, -- Shortcut

		{ "<leader>bc", group = "Close" },
		{ "<leader>bca", "<cmd>%Bwipeout<cr>", desc = "All" },
		{ "<leader>bcc", "<cmd>Bwipeout<cr>", desc = "Current" },
		{ "<leader>bco", '<cmd>%Bdelete | e # | normal `"<cr>', desc = "Others" },
	})
end

return M
