local M = {
	"nvim-treesitter/nvim-treesitter-context",
}

function M.config()
	require("treesitter-context").setup()
end

return M
