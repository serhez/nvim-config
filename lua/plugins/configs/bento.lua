local M = {
	"serhez/bento.nvim",
	dev = true,
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
}

function M.config()
	require("bento").setup({
		max_open_buffers = 10,
	})
end

return M
