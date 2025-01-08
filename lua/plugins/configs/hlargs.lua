local M = {
	"m-demare/hlargs.nvim",
	event = "VeryLazy",
}

function M.config()
	require("hlargs").setup({
		extras = {
			named_parameters = { link = "Hlargs" },
			unused_args = { link = "Comment" },
		},
	})

	-- Function parameters highlighting (used by hlargs)
	-- vim.cmd("autocmd ColorScheme * highlight! link Hlargs TSParameter")
	-- vim.cmd("highlight! link Hlargs TSParameter")
end

return M
