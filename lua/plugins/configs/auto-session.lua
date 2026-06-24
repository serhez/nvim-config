local M = {
	"rmagatti/auto-session",
	lazy = false,
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

local function _get_tmux_tag()
	local tmux_tag = ""

	if vim.env.TMUX then
		local session_handle = io.popen("tmux display-message -p '#S'")
		if session_handle ~= nil then
			local session_name = session_handle:read("*a")
			session_handle:close()
			tmux_tag = tmux_tag .. session_name:gsub("\n", "")
		else
			tmux_tag = tmux_tag .. "__session__"
		end

		local window_name_handle = io.popen("tmux display-message -p '#W'")
		if window_name_handle ~= nil then
			local window_name = window_name_handle:read("*a")
			window_name_handle:close()
			tmux_tag = tmux_tag .. ":" .. window_name:gsub("\n", "")
		else
			tmux_tag = tmux_tag .. "__window__"
		end

		-- NOTE: I like it better without accounting for the window index
		--       I can rearrange windows without affecting sessions
		--       This means that, to have unique sessions for a given window, I must give it
		--       a unique name for that session.
		-- local window_index_handle = io.popen("tmux display-message -p '#I'")
		-- if window_index_handle ~= nil then
		-- 	local window_index = window_index_handle:read("*a")
		-- 	window_index_handle:close()
		-- 	tmux_tag = tmux_tag .. ":" .. window_index:gsub("\n", "")
		-- else
		-- 	tmux_tag = tmux_tag .. "__index__"
		-- end
	end

	return tmux_tag
end

vim.g.auto_session_custom_tag = nil

-- Patch the "E944: Reverse range in character class" crash on VimEnter.
--
-- auto-session derives the session file name from the cwd via
-- Lib.percent_encode, which escapes "/ \ : * ? \" ' < > + space | . %" but NOT
-- square brackets. So a cwd like ~/Downloads/[NeurIPS-26] .../ keeps "[..]" in
-- the session path. Lib.expand then feeds that path to vim.fn.expand, which
-- treats "[..]" as a glob character class; "[NeurIPS-26]" contains the range
-- "S-2" (S > 2), so Vim raises E944 and the whole VimEnter autorestore aborts.
--
-- Lib.expand only ever wants to canonicalize a path (expand ~/env, make it
-- absolute) -- it never wants glob behaviour -- so we keep the original for the
-- normal case and only fall back to a glob-free canonicalization when expand
-- throws. Minimal blast radius: identical output for every non-crashing input.
local function patch_expand_glob_crash()
	local ok, Lib = pcall(require, "auto-session.lib")
	if not ok or type(Lib) ~= "table" or Lib.__expand_glob_guard then
		return
	end
	local original_expand = Lib.expand
	if type(original_expand) ~= "function" then
		return
	end

	function Lib.expand(file_or_dir)
		local got, ret = pcall(original_expand, file_or_dir)
		if got then
			return ret
		end
		return vim.fn.fnamemodify(vim.fs.normalize(file_or_dir), ":p")
	end
	Lib.__expand_glob_guard = true
end

function M.config()
	patch_expand_glob_crash()

	require("auto-session").setup({
		git_use_branch_name = true, -- Include git branch name in session name
		git_auto_restore_on_branch_change = true, -- Should we auto-restore the session when the git branch changes. Requires git_use_branch_name
		show_auto_restore_notif = true, -- Whether to show a notification when auto-restoring
		cwd_change_handling = true, -- Follow cwd changes, saving a session before change and restoring after
		log_level = "info", -- Sets the log level of the plugin (debug, info, warn, error).

		-- Different sessions for tmux sessions & windows
		custom_session_tag = function(_)
			if vim.g.auto_session_custom_tag == nil then
				vim.g.auto_session_custom_tag = _get_tmux_tag()
			end
			return vim.g.auto_session_custom_tag
		end,

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
