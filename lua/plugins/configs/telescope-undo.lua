local M = {
	"debugloop/telescope-undo.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	cmd = { "Telescope undo" },
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		F = {
			u = { "<cmd>Telescope undo theme=ivy<cr>", "Undo" },
		},
	})
end

function M.config()
	local present, telescope = pcall(require, "telescope")
	if present then
		telescope.load_extension("undo")
	end
end

return M
