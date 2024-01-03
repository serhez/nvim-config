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

function M.config()
	local present, telescope = pcall(require, "telescope")
	if present then
		telescope.load_extension("frecency")
	end
end

return M
