local M = {
	"jbyuki/nabla.nvim",
	cmd = "Nabla",
}

function M.init()
	vim.api.nvim_create_user_command("Nabla", "lua require('nabla').popup()", {})
end

return M
