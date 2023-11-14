local M = {
	"olimorris/persisted.nvim",
	event = "VimEnter",
	-- dependencies = { -- These plugins are loaded before the session is restored, so that they can properly restore buffers (pinned, etc.)
	-- 	"akinsho/bufferline.nvim",
	-- 	"axkirillov/hbac.nvim",
	-- },
	cond = not vim.g.started_by_firenvim,
}

function _G.close_all_wins()
	local present, edgy = pcall(require, "edgy")
	if present then
		edgy.close()
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
		end
	end
end

function _G.session_load_third_parties()
	local present, vuffers = pcall(require, "vuffers")
	if present then
		vuffers.on_session_loaded()
	end
end

function M.config()
	require("persisted").setup({
		silent = false, -- silent nvim message when sourcing session file
		use_git_branch = true, -- create session files based on the branch of the git enabled repository
		autosave = true, -- automatically save session files when exiting Neovim
		should_autosave = nil, -- function to determine if a session should be autosaved
		autoload = true, -- automatically load the session for the cwd on Neovim startup
		on_autoload_no_session = function()
			vim.notify("No existing session to load.")
		end, -- function to run when `autoload = true` but there is no session to load
		follow_cwd = true, -- change session file name to match current working directory if it changes
		allowed_dirs = {
			"~/.config",
			"~/dev",
			"~/scripts",
			"~/courses",
			"~/Documents/academic/aalto/courses",
		}, -- table of dirs that the plugin will auto-save and auto-load from
		ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
		telescope = { -- options for the telescope extension
			reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
		},
	})

	-- Callbacks
	local group = vim.api.nvim_create_augroup("PersistedHooks", {})
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "PersistedSavePre",
		group = group,
		callback = function()
			_G.close_all_wins()
		end,
	})
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "PersistedLoadPost",
		group = group,
		callback = function()
			_G.session_load_third_parties()
		end,
	})
end

return M
