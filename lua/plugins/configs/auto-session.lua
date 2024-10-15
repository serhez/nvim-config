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
		auto_session_enabled = true,
		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
		auto_save_enabled = true,
		auto_restore_enabled = true,
		auto_session_suppress_dirs = nil,
		auto_session_allowed_dirs = {
			"~/.config/*",
			"~/dev/*",
			"~/scripts/*",
			"~/courses/*",
			"~/Documents/academic/aalto/courses/*",
		},
		auto_session_create_enabled = true,
		auto_session_enable_last_session = false, -- On startup, loads the last loaded session if session for cwd does not exist
		auto_session_use_git_branch = true,
		auto_restore_lazy_delay_enabled = true,
		log_level = "error",
		close_unsupported_windows = true, -- boolean: Close windows that aren't backed by normal file
		cwd_change_handling = { -- table: Config for handling the DirChangePre and DirChanged autocmds, can be set to nil to disable altogether
			restore_upcoming_session = true, -- boolean: restore session for upcoming cwd on cwd change
		},
		args_allow_single_directory = true, -- boolean Follow normal sesion save/load logic if launched with a single directory as the only argument
		args_allow_files_auto_save = false, -- boolean|function Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
		silent_restore = false, -- Suppress extraneous messages and source the whole session, even if there's an error. Set to false to get the line number a restore error
		session_lens = {
			load_on_setup = false,
		},
	})
end

return M
