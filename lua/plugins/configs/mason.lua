local M = {
	"williamboman/mason.nvim",
}

function M.init()
	require("mappings").register({ "<leader>is", "<cmd>Mason<cr>", desc = "Servers" })
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
