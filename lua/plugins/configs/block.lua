local M = {
	"HampusHauffman/block.nvim",
	cmd = "Block",
}

function M.init()
	require("mappings").register({ "<leader>Ub", "<cmd>Block<cr>", desc = "Indent blocks" })
end

function M.config()
	require("block").setup()
end

return M
