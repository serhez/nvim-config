local M = {
	"nvim-telescope/telescope-frecency.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	cmd = { "Telescope frecency" },
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	local mappings = require("mappings")
	mappings.register({ "<leader>f", "<cmd>Telescope frecency theme=ivy<cr>", desc = "Find files" })
end

return M
