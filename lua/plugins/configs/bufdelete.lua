local mappings = require("mappings")

local M = {
	"famiu/bufdelete.nvim",
	event = "BufReadPre",
}

function M.init()
	mappings.register_normal({
		q = { "<cmd>Bwipeout<cr>", "Quit buffer" }, -- Shortcut
		b = {
			c = {
				name = "Close",
				A = { "<cmd>%Bwipeout<cr>", "All" },
				c = { "<cmd>Bwipeout<cr>", "Current" },
				o = { '<cmd>%Bdelete | e # | normal `"<cr>', "Others" },
			},
		},
	})
end

return M
