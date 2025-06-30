local M = {
	"williamboman/mason.nvim",
	cond = not vim.g.started_by_firenvim and not vim.g.slow_network,
}

function M.init()
	require("mappings").register({ "<leader>is", "<cmd>Mason<cr>", desc = "Servers panel" })
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
