local mappings = require("mappings")

local M = {
	"miversen33/netman.nvim",
	branch = "v1.1",
	cmd = {
		"Neotree",
		"NmloadProvider",
		"Nmlogs",
		"Nmdelete",
		"Nmread",
		"Nmwrite",
	},
}

function M.init()
	mappings.register_normal({
		E = { "<cmd>Neotree remote<cr>", "Explorer (remote)" },
	})
end

function M.config()
	require("netman")
end

return M
