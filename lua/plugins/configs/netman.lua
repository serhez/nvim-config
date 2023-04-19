local M = {
	"miversen33/netman.nvim",
	-- NOTE: Currently loaded as a dependency of neo-tree
}

function M.config()
	require("netman")
end

return M
