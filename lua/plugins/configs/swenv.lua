local mappings = require("mappings")

local M = {
	"AckslD/swenv.nvim",
	-- TODO: This is currently loaded by feline on startup always; do it only when an env is picked
}

function M.init()
	vim.api.nvim_create_user_command("PickVenv", "lua require('swenv.api').pick_venv()", {})
	vim.api.nvim_create_user_command("GetVenv", "lua require('swenv.api').get_current_venv()", {})

	mappings.register_normal({
		l = {
			v = { "<cmd>PickVenv<cr>", "Virtual environments" },
		},
	})
end

function M.config()
	require("swenv").setup({
		-- Should return a list of tables with a `name` and a `path` entry each
		-- Gets the argument `venvs_path` set below
		-- By default just lists the entries in `venvs_path`
		get_venvs = function(venvs_path)
			local global_venvs = require("swenv.api").get_venvs(venvs_path)
			local workspace_venvs = require("swenv.api").get_venvs(vim.fn.getcwd())
			return vim.tbl_deep_extend("force", global_venvs, workspace_venvs)
		end,
		-- Path passed to `get_venvs`
		venvs_path = vim.fn.expand("~/.envs"),
		-- Something to do after setting an environment, for example call vim.cmd.LspRestart
		post_set_venv = nil,
	})
end

return M
