local M = {
	"HampusHauffman/block.nvim",
	cmd = "Block",
}

function M.init()
	local mappings = require("mappings")

	mappings.register_normal({
		U = {
			b = { "<cmd>Block<cr>", "Indent blocks" },
		},
	})
end

function M.config()
	require("block").setup()
end

return M
