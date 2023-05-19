local mappings = require("mappings")

local M = {
	"AckslD/swenv.nvim",
	event = "VeryLazy",
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
	local feline_config = require("plugins.configs.feline")
	require("swenv").setup({
		-- Should return a list of tables with a `name` and a `path` entry each
		-- Gets the argument `venvs_path` set below
		-- By default just lists the entries in `venvs_path`
		get_venvs = function(venvs_path)
			local global_venvs = require("swenv.api").get_venvs(venvs_path)
			local workspace_venvs = require("swenv.api").get_venvs(vim.fn.getcwd() .. "/venv")
			return vim.tbl_deep_extend("force", global_venvs, workspace_venvs)
		end,
		-- Path passed to `get_venvs`
		venvs_path = vim.fn.expand("~/.envs"),
		-- Something to do after setting an environment, for example call vim.cmd.LspRestart
		post_set_venv = function(venv)
			vim.cmd("LspRestart")
			feline_config.set_venv(venv.name)
		end,
	})

	feline_config.set_venv(require("swenv.api").get_current_venv().name)
end

return M
