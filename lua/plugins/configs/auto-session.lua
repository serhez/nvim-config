local M = {
	"rmagatti/auto-session",
	event = "VimEnter",
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

function M.config()
	require("auto-session").setup({
		log_level = "error",
		auto_session_enabled = true,
		auto_session_create_enabled = true,
		auto_session_enable_last_session = false,
		auto_save_enabled = true,
		auto_restore_enabled = true,
		auto_session_use_git_branch = true,
		cwd_change_handling = {
			restore_upcoming_session = true,
		},
		pre_save_cmds = { _G.close_all_wins },
		auto_session_suppress_dirs = { "~/", "~/.config", "~/Downloads" },
	})
end

return M
