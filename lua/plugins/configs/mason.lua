local mappings = require("mappings")

local M = {
	"williamboman/mason.nvim",
}

function M.init()
	mappings.register_normal({
		i = {
			s = { "<cmd>Mason<cr>", "Servers" },
		},
	})
end

function M.config()
	require("mason").setup({
		ui = {
			-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
			border = "none",
		},
	})
end

return M
