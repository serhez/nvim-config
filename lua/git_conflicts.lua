local M = {}

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Git conflicts" })
end

local function current_codediff_conflict()
	local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
	if not ok then
		return nil, nil
	end

	local tabpage = lifecycle.find_tabpage_by_buffer(vim.api.nvim_get_current_buf())
	if not tabpage then
		return nil, nil
	end

	local session = lifecycle.get_session(tabpage)
	if not session or not session.result_bufnr or not session.conflict_blocks then
		return nil, nil
	end

	return tabpage, session
end

local function refresh_unclash(bufnr, path)
	local ok_conflict, conflict = pcall(require, "unclash.conflict")
	if not ok_conflict then
		return
	end

	local hunks = conflict.detect_conflicts(bufnr)
	conflict.highlight_conflicts(bufnr, hunks)

	local ok_state, state = pcall(require, "unclash.state")
	if ok_state and path and path ~= "" and hunks and #hunks > 0 then
		state.maybe_conflicted_files[path] = true
	end
end

local function with_unclash(action)
	local ok, unclash = pcall(require, "unclash")
	if not ok then
		notify("unclash.nvim is not available", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	refresh_unclash(bufnr, vim.api.nvim_buf_get_name(bufnr))
	action(unclash)
end

local function codediff_action(name, result_only)
	local tabpage, session = current_codediff_conflict()
	if not tabpage or (result_only and vim.api.nvim_get_current_buf() ~= session.result_bufnr) then
		return false
	end

	local ok, conflict = pcall(require, "codediff.ui.conflict")
	if not ok or type(conflict[name]) ~= "function" then
		return false
	end

	conflict[name](tabpage)
	return true
end

function M.accept_current()
	if codediff_action("diffget_current", true) or codediff_action("accept_current") then
		return
	end
	with_unclash(function(unclash)
		unclash.accept_current()
	end)
end

function M.accept_incoming()
	if codediff_action("diffget_incoming", true) or codediff_action("accept_incoming") then
		return
	end
	with_unclash(function(unclash)
		unclash.accept_incoming()
	end)
end

function M.accept_both()
	if codediff_action("accept_both") then
		return
	end
	with_unclash(function(unclash)
		unclash.accept_both()
	end)
end

function M.discard()
	if codediff_action("discard") then
		return
	end
	with_unclash(function(unclash)
		unclash.accept("base")
	end)
end

function M.next_conflict()
	if codediff_action("navigate_next_conflict") then
		return
	end
	with_unclash(function(unclash)
		unclash.next_conflict({ wrap = true })
	end)
end

function M.prev_conflict()
	if codediff_action("navigate_prev_conflict") then
		return
	end
	with_unclash(function(unclash)
		unclash.prev_conflict({ wrap = true })
	end)
end

function M.open_merge_editor()
	with_unclash(function(unclash)
		unclash.open_merge_editor()
	end)
end

return M
