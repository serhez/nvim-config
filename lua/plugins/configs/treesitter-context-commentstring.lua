local M = {
	"JoosepAlviste/nvim-ts-context-commentstring",
}

function M.config()
	vim.g.skip_ts_context_commentstring_module = true

	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})
end

return M

