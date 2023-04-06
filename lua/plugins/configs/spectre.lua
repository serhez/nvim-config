local mappings = require("mappings")

local M = {
	"windwp/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Spectre",
}

function M.init()
	vim.api.nvim_create_user_command("Spectre", "lua require('spectre').open()", {})

	mappings.register_normal({
		S = { "<cmd>Spectre<cr>", "Search & replace" },
	})
end

function M.config()
	require("spectre").setup({
		open_cmd = "vnew",
		live_update = true, -- auto excute search again when you write any file in vim
	})
end

return M
