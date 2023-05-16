local mappings = require("mappings")

local M = {
	"serhez/venv.nvim",
	cmd = {
		"PickVenv",
		"GetVenv",
	},
}

function M.init()
	vim.api.nvim_create_user_command("PickVenv", "lua require('venv').pick_venv()", {})
	vim.api.nvim_create_user_command("GetVenv", "lua require('venv').get_current_venv()", {})

	mappings.register_normal({
		f = {
			v = { "<cmd>PickVenv<cr>", "Virtual environments" },
		},
	})
end

function M.config()
	require("venv").setup()
end

return M
