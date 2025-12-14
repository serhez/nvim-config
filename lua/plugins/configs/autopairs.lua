local M = {
	"windwp/nvim-autopairs",
	event = { "InsertEnter", "CmdlineEnter" },
	enabled = false,
}

function M.config()
	require("nvim-autopairs").setup()
end

return M
