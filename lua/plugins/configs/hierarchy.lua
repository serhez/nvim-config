local M = {
	"lafarr/hierarchy.nvim",
	event = "LspAttach",
}

function M.init()
	require("mappings").register({ "<leader>cc", "<cmd>FunctionReferences<cr>", desc = "Calls hierarchy" })
end

function M.config()
	require("hierarchy").setup({
		depth = 5,
	})
end

return M
