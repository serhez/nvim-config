local M = {
	"jedrzejboczar/possession.nvim",
	event = "VimEnter",
	dependencies = { -- These plugins are loaded before the session is restored, so that they can properly restore buffers (pinned, etc.)
		-- 	"akinsho/bufferline.nvim",
		-- 	"axkirillov/hbac.nvim",
		"nvim-lua/plenary.nvim",
	},
	cond = not vim.g.started_by_firenvim,
}

-- function _G.close_all_wins()
-- 	local present, edgy = pcall(require, "edgy")
-- 	if present then
-- 		edgy.close()
-- 	end
--
-- 	for _, win in ipairs(vim.api.nvim_list_wins()) do
-- 		local config = vim.api.nvim_win_get_config(win)
-- 		if config.relative ~= "" then
-- 			vim.api.nvim_win_close(win, false)
-- 		end
-- 	end
-- end

-- function _G.session_load_third_parties()
-- 	local present, vuffers = pcall(require, "vuffers")
-- 	if present then
-- 		vuffers.on_session_loaded()
-- 	end
-- end

function M.config()
	require("possession").setup({
		silent = false,
		load_silent = true,
		debug = false,
		logfile = false,
		prompt_no_cr = false,
		autosave = {
			current = true, -- or fun(name): boolean
			tmp = true, -- or fun(): boolean
			tmp_name = "tmp", -- or fun(): string
			on_load = true,
			on_quit = true,
		},
		hooks = {
			before_save = function(name)
				return {}
			end,
			after_save = function(name, user_data, aborted) end,
			before_load = function(name, user_data)
				return user_data
			end,
			after_load = function(name, user_data)
				return _G.session_load_third_parties()
			end,
		},
		plugins = {
			close_windows = {
				hooks = { "before_save", "before_load" },
				preserve_layout = true, -- or fun(win): boolean
				match = {
					floating = true,
					buftype = {},
					filetype = {},
					custom = false, -- or fun(win): boolean
				},
			},
			delete_hidden_buffers = {
				hooks = {
					"before_load",
					vim.o.sessionoptions:match("buffer") and "before_save",
				},
				force = false, -- or fun(buf): boolean
			},
			nvim_tree = false,
			neo_tree = true,
			symbols_outline = false,
			tabby = false,
			dap = true,
			dapui = true,
			delete_buffers = false,
		},
		telescope = {
			previewer = {
				enabled = true,
				previewer = "pretty", -- or 'raw' or fun(opts): Previewer
				wrap_lines = true,
				include_empty_plugin_data = false,
				cwd_colors = {
					cwd = "Comment",
					tab_cwd = { "#cc241d", "#b16286", "#d79921", "#689d6a", "#d65d0e", "#458588" },
				},
			},
			list = {
				default_action = "load",
				mappings = {
					save = { n = "<c-x>", i = "<c-x>" },
					load = { n = "<c-v>", i = "<c-v>" },
					delete = { n = "<c-t>", i = "<c-t>" },
					rename = { n = "<c-r>", i = "<c-r>" },
				},
			},
		},
	})
end

return M
