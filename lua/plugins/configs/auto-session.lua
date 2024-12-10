local M = {
	"rmagatti/auto-session",
	lazy = false,
	-- dependencies = { -- These plugins are loaded before the session is restored, so that they can properly restore buffers (pinned, etc.)
	-- 	"akinsho/bufferline.nvim",
	-- 	"axkirillov/hbac.nvim",
	-- },
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	require("auto-session").setup({
		enabled = true, -- Enables/disables auto creating, saving and restoring
		auto_save = true, -- Enables/disables auto saving session on exit
		auto_restore = true, -- Enables/disables auto restoring session on start
		auto_create = true, -- Enables/disables auto creating new session files. Can take a function that should return true/false if a new session file should be created or not
		auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
		use_git_branch = true, -- Include git branch name in session name
		lazy_support = true, -- Automatically detect if Lazy.nvim is being used and wait until Lazy is done to make sure session is restored correctly. Does nothing if Lazy isn't being used. Can be disabled if a problem is suspected or for debugging
		close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session
		args_allow_single_directory = true, -- Follow normal sesion save/load logic if launched with a single directory as the only argument
		args_allow_files_auto_save = false, -- Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
		continue_restore_on_error = true, -- Keep loading the session even if there's an error
		show_auto_restore_notif = true, -- Whether to show a notification when auto-restoring
		cwd_change_handling = true, -- Follow cwd changes, saving a session before change and restoring after
		lsp_stop_on_restore = false, -- Should language servers be stopped when restoring a session. Can also be a function that will be called if set. Not called on autorestore from startup
		log_level = "info", -- Sets the log level of the plugin (debug, info, warn, error).
		session_lens = {
			load_on_setup = false, -- Initialize on startup (requires Telescope)
		},

		-- BUG: Cannot use this, because the algorithm attempts to match the cwd
		--      with every single possible directory in the list, which is
		--      extremely slow for something like `~/dev/**/*` (e.g., it checks
		--      `node_modules`).
		-- allowed_dirs = {
		-- 	"~/.config/*",
		-- 	"~/dev/**/*",
		-- 	"~/scripts/*",
		-- 	"~/courses/*",
		-- 	"~/Documents/academic/aalto/courses/*",
		-- },
	})
end

return M
