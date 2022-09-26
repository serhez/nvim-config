local utils = require("utils")

local swenv = require("swenv")
local swenv_api = require("swenv.api")

-- FIX: This plugin (1) does not work as expected and (2) does not detect venvs from the project root folder
--      However, there are no other plugins providing this functionality
--      Let's wait to see how it evolves
swenv.setup({
	-- Should return a list of tables with a `name` and a `path` entry each.
	-- Gets the argument `venvs_path` set below.
	-- By default just lists the entries in `venvs_path`.
	get_venvs = function(venvs_path)
		return utils.concat_tables(swenv_api.get_venvs(venvs_path), swenv_api.get_venvs(vim.fn.expand(".")))
	end,
	-- Path passed to `get_venvs`.
	venvs_path = vim.fn.expand("~/venvs"),
	-- Something to do after setting an environment
	post_set_venv = nil,
})
