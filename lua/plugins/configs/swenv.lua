local M = {
	"AckslD/swenv.nvim",
	dev = true,
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

vim.g.active_venv = nil

function M.init()
	require("mappings").register({
		"<leader>v",
		function()
			require("swenv.api").pick_venv()
		end,
		desc = "Virtual environments",
	})
end

function M.config()
	require("swenv").setup({
		-- attempt to auto create and set a venv from dependencies
		auto_create_venv = false,

		-- Should return a list of tables with a `name` and a `path` entry each
		-- Gets the argument `venvs_path` set below
		-- By default just lists the entries in `venvs_path`
		get_venvs = function(venvs_path)
			-- Global dir (my conda config)
			local all_venvs = require("swenv.api").get_venvs(venvs_path)

			-- Just in case
			local other_venvs = require("swenv.api").get_venvs("~/.envs")
			all_venvs = vim.tbl_deep_extend("force", all_venvs, other_venvs)

			-- Just in case
			other_venvs = require("swenv.api").get_venvs("~/venvs")
			all_venvs = vim.tbl_deep_extend("force", all_venvs, other_venvs)

			-- Just in case
			other_venvs = require("swenv.api").get_venvs("~/.venvs")
			all_venvs = vim.tbl_deep_extend("force", all_venvs, other_venvs)

			-- Regular venvs
			other_venvs = require("swenv.api").get_venvs(vim.fn.getcwd() .. "/venv")
			all_venvs = vim.tbl_deep_extend("force", all_venvs, other_venvs)

			-- uv
			other_venvs = require("swenv.api").get_venvs(vim.fn.getcwd() .. "/.venv")
			all_venvs = vim.tbl_deep_extend("force", all_venvs, other_venvs)

			-- pixi
			other_venvs = require("swenv.api").get_venvs(vim.fn.getcwd() .. "/.pixi/envs")
			all_venvs = vim.tbl_deep_extend("force", all_venvs, other_venvs)

			return all_venvs
		end,

		-- Path passed to `get_venvs`
		venvs_path = vim.fn.expand("~/envs"),

		-- Something to do after setting an environment, for example call vim.cmd.LspRestart
		post_set_venv = function(venv)
			vim.g.active_venv = venv.name
			vim.cmd("LspRestart")
		end,
	})

	-- Initialize the active virtual environment
	local current_venv = require("swenv.api").get_current_venv()
	if current_venv then
		vim.g.active_venv = current_venv.name
	end
end

return M
