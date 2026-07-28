local M = {
	"JoosepAlviste/nvim-ts-context-commentstring",
}

function M.config()
	-- Skip the legacy nvim-treesitter module registration (gone on the main branch).
	vim.g.skip_ts_context_commentstring_module = true

	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})
end

return M
