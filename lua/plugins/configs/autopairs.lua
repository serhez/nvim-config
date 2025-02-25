local M = {
	"windwp/nvim-autopairs",
	event = { "InsertEnter", "CmdlineEnter" },
}

function M.config()
	require("nvim-autopairs").setup()
end

return M
