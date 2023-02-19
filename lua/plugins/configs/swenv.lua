local mappings = require("mappings")

-- FIX: This plugin (1) does not work as expected and (2) does not detect venvs from the project root folder
--      However, there are no other plugins providing this functionality
--      Let's wait to see how it evolves
local M = {
	"AckslD/swenv.nvim",
	ft = "python",
}

function _G.pick_venv(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local venvs_path = vim.fn.expand("~/.envs")
	local present, swenv = pcall(require, "swenv.api")
	if not present then
		return
	end

	opts = opts or {}

	local venvs = swenv.get_venvs(venvs_path)
	local venvs_list = {}
	for _, venv in ipairs(venvs) do
		table.insert(venvs_list, venv.name)
	end

	pickers
		.new(opts, {
			prompt_title = "Virtual environments",
			finder = finders.new_table({
				results = venvs_list,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local venv_path = venvs_path .. "/" .. selection.value
					vim.fn.setenv("PATH", venv_path .. "/bin" .. ":" .. vim.fn.getenv("PATH"))
					vim.fn.setenv("VIRTUAL_ENV", venv_path)
				end)
				return true
			end,
		})
		:find()
end

function M.init()
	vim.api.nvim_create_user_command("PickPythonVenv", "lua _G.pick_venv()", {})
	vim.api.nvim_create_user_command("GetPythonVenv", "lua require('swenv.api').get_current_venv()", {})

	mappings.register_normal({
		f = {
			v = { "<cmd>PickPythonVenv<cr>", "Virtual environments" },
		},
	})
end

function M.config()
	require("swenv").setup({
		-- Should return a list of tables with a `name` and a `path` entry each.
		-- Gets the argument `venvs_path` set below.
		-- By default just lists the entries in `venvs_path`.
		get_venvs = function(venvs_path)
			return require("swenv.api").get_venvs(venvs_path)
		end,
		-- Path passed to `get_venvs`.
		venvs_path = vim.fn.expand("~/.envs"),
		-- Something to do after setting an environment
		post_set_venv = nil,
	})
end

return M
