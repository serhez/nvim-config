local mappings = require("mappings")

local M = {
	"windwp/nvim-spectre",
	cmd = "Spectre",
}

function M.init()
	vim.api.nvim_create_user_command("Spectre", "lua require('spectre').open()", {})

	mappings.register_normal({
		u = {
			s = { "<cmd>Spectre<cr>", "Search & replace" },
		},
	})
end

function M.config()
	require("spectre").setup({
		live_update = false, -- auto excute search again when you write any file in vim
	})
end

return M
