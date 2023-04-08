local mappings = require("mappings")

local M = {
	"miversen33/netman.nvim",
	-- NOTE: Currently loaded as a dependency of neo-tree
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
