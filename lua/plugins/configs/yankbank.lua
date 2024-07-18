local M = {
	"ptdewey/yankbank-nvim",
	cmd = "YankBank",
}

function M.init()
	require("mappings").register({ "<leader>y", "<cmd>YankBank<cr>", desc = "Yank history" })
end

function M.config()
	require("yankbank").setup()
end

return M
