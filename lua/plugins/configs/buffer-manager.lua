local M = {
	"j-morano/buffer_manager.nvim",
	dev = true,
	name = "buffer_manager.nvim",
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
}

function M.config()
	require("buffer_manager").setup({
		hl_open = "DiagnosticVirtualTextHint",
		hl_delete = "DiagnosticVirtualTextError",
	})
end

return M
