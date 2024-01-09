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
	mappings.register_normal({
		f = {
			"<cmd>Telescope frecency theme=ivy<cr>",
			"Find files",
		},
		F = {
			f = {
				"<cmd>Telescope frecency theme=ivy<cr>",
				"Files",
			},
		},
	})
end

return M
