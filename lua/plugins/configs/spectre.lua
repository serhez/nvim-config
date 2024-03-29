local mappings = require("mappings")

local M = {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Spectre",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	vim.api.nvim_create_user_command("Spectre", "lua require('spectre').open()", {})

	mappings.register_normal({
		r = { "<cmd>Spectre<cr>", "Replace text" },
	})
end

function M.config()
	require("spectre").setup({
		open_cmd = "vnew",
		live_update = true, -- auto excute search again when you write any file in vim
	})
end

return M
