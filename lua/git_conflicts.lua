local M = {}

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Git conflicts" })
end

local function current_codediff_conflict()
	local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
	if not ok then
		return nil, nil
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local tabpage = lifecycle.find_tabpage_by_buffer(bufnr)
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

local function codediff_action(name)
	local tabpage = current_codediff_conflict()
	if not tabpage then
		return false
	end

	local ok_actions, actions = pcall(require, "codediff.ui.conflict.actions")
	if not ok_actions or type(actions[name]) ~= "function" then
		return false
	end

	actions[name](tabpage)
	return true
end

local function codediff_diffget(name)
	local tabpage, session = current_codediff_conflict()
	if not tabpage or not session then
		return false
	end

	if vim.api.nvim_get_current_buf() ~= session.result_bufnr then
		return false
	end

	local ok_diffget, diffget = pcall(require, "codediff.ui.conflict.diffget")
	if not ok_diffget or type(diffget[name]) ~= "function" then
		return false
	end

	diffget[name](tabpage)
	return true
end

function M.accept_current()
	if codediff_diffget("diffget_current") or codediff_action("accept_current") then
		return
	end
	with_unclash(function(unclash)
		unclash.accept_current()
	end)
end

function M.accept_incoming()
	if codediff_diffget("diffget_incoming") or codediff_action("accept_incoming") then
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
	local tabpage = current_codediff_conflict()
	if tabpage then
		local ok_navigation, navigation = pcall(require, "codediff.ui.conflict.navigation")
		if ok_navigation then
			navigation.navigate_next_conflict(tabpage)
			return
		end
	end

	with_unclash(function(unclash)
		unclash.next_conflict({ wrap = true })
	end)
end

function M.prev_conflict()
	local tabpage = current_codediff_conflict()
	if tabpage then
		local ok_navigation, navigation = pcall(require, "codediff.ui.conflict.navigation")
		if ok_navigation then
			navigation.navigate_prev_conflict(tabpage)
			return
		end
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

local function open_conflict_file_from_explorer(explorer, file_data)
	if not explorer.git_root then
		notify("CodeDiff conflict handoff only works in git repositories", vim.log.levels.WARN)
		return
	end

	local path = file_data and file_data.path
	if not path or path == "" then
		notify("No conflict file selected", vim.log.levels.WARN)
		return
	end

	local abs_path = explorer.git_root .. "/" .. path
	local ok_lifecycle, lifecycle = pcall(require, "codediff.ui.lifecycle")
	local modified_win
	if ok_lifecycle then
		local _
		_, modified_win = lifecycle.get_windows(explorer.tabpage)
	end

	if modified_win and vim.api.nvim_win_is_valid(modified_win) then
		vim.api.nvim_set_current_win(modified_win)
	end

	local ok, err = pcall(vim.cmd, "silent edit " .. vim.fn.fnameescape(abs_path))
	if not ok then
		notify("Failed to open conflict file: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	vim.b[bufnr].unclash_from_codediff = true
	refresh_unclash(bufnr, abs_path)
end

local function select_codediff_explorer_entry(opts)
	opts = opts or {}

	local ok_lifecycle, lifecycle = pcall(require, "codediff.ui.lifecycle")
	if not ok_lifecycle then
		return
	end

	local explorer = lifecycle.get_explorer(vim.api.nvim_get_current_tabpage())
	if not explorer or not explorer.tree then
		return
	end

	local node = explorer.tree:get_node()
	if not node or not node.data then
		return
	end

	if node.data.type == "group" or node.data.type == "directory" then
		if node:is_expanded() then
			node:collapse()
		else
			node:expand()
		end
		explorer.tree:render()
		return
	end

	if node.data.group == "conflicts" then
		explorer.current_file_path = node.data.path
		explorer.current_file_group = node.data.group
		explorer.current_selection = vim.deepcopy(node.data)
		open_conflict_file_from_explorer(explorer, node.data)
		return
	end

	explorer.on_file_select(node.data)

	if opts.focus_on_select then
		local ok_config, config = pcall(require, "codediff.config")
		if ok_config and config.options.explorer.focus_on_select then
			vim.schedule(function()
				local _, modified_win = lifecycle.get_windows(explorer.tabpage)
				if modified_win and vim.api.nvim_win_is_valid(modified_win) then
					vim.api.nvim_set_current_win(modified_win)
				end
			end)
		end
	end
end

local function setup_codediff_explorer_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "codediff-explorer" then
		return
	end

	local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
	vim.keymap.set("n", "<CR>", function()
		select_codediff_explorer_entry({ focus_on_select = true })
	end, vim.tbl_extend("force", opts, { desc = "Select entry" }))

	vim.keymap.set("n", "<2-LeftMouse>", function()
		select_codediff_explorer_entry()
	end, vim.tbl_extend("force", opts, { desc = "Select entry" }))
end

function M.setup_codediff_explorer()
	local group = vim.api.nvim_create_augroup("UserCodeDiffUnclash", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "codediff-explorer",
		callback = function(args)
			vim.schedule(function()
				setup_codediff_explorer_buffer(args.buf)
			end)
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "CodeDiffOpen",
		callback = function()
			vim.schedule(function()
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					setup_codediff_explorer_buffer(bufnr)
				end
			end)
		end,
	})
end

return M
