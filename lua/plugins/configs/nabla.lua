local mappings = require("mappings")

local M = {
	"jbyuki/nabla.nvim",
	cmd = "Nabla",
}

function M.init()
	vim.api.nvim_create_user_command("Nabla", "lua require('nabla').popup()", {})

	mappings.register_normal({
		l = {
			p = { "<cmd>Nabla<cr>", "Preview formula" },
		},
	})
end

return M
