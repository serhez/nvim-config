local M = {
	"serhez/buffer_manager.nvim",
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
}

function M.config()
	require("buffer_manager").setup({
		hl_open = "DiagnosticVirtualTextHint",
		hl_delete = "DiagnosticVirtualTextError",
		max_open_buffers = 7,
		show_minimal_menu = false,
	})
end

return M
