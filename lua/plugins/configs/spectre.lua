local M = {
	"windwp/nvim-spectre",
	cmd = "Spectre",
}

function M.init()
	vim.api.nvim_create_user_command("Spectre", "lua require('spectre').open()", {})
end

function M.config()
	require("spectre").setup()
end

return M
