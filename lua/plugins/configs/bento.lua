local M = {
	"serhez/bento.nvim",
	dev = true,
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
}

function M.config()
	require("bento").setup({
		hl_open = "DiagnosticVirtualTextHint",
		hl_delete = "DiagnosticVirtualTextError",
		max_open_buffers = 10,
		show_minimal_menu = false,
	})
end

return M
