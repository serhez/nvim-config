local M = {
	"kylechui/nvim-surround",
	event = "InsertEnter",
}

function M.config()
	require("nvim-surround").setup()
end

return M
