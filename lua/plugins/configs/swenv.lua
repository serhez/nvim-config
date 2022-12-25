local utils = require("utils")

-- FIX: This plugin (1) does not work as expected and (2) does not detect venvs from the project root folder
--      However, there are no other plugins providing this functionality
--      Let's wait to see how it evolves
local M = {
	"AckslD/swenv.nvim",
	cmd = "PickPythonVenv",
}

function M.init()
	vim.api.nvim_create_user_command("PickPythonVenv", "lua require('swenv.api').pick_venv()", {})
end

function M.config()
	local swenv_api = require("swenv.api")

	require("swenv").setup({
		-- Should return a list of tables with a `name` and a `path` entry each.
		-- Gets the argument `venvs_path` set below.
		-- By default just lists the entries in `venvs_path`.
		get_venvs = function(venvs_path)
			return utils.concat_tables(swenv_api.get_venvs(venvs_path), swenv_api.get_venvs(vim.fn.expand(".")))
		end,
		-- Path passed to `get_venvs`.
		venvs_path = vim.fn.expand("~/.envs"),
		-- Something to do after setting an environment
		post_set_venv = nil,
	})
end

return M
