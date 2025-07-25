local M = {
	"echasnovski/mini.files",
	version = false,
	enabled = false,
}

local minifiles_toggle = function()
	local mini_files = require("mini.files")
	if not mini_files.close() then
		mini_files.open(vim.api.nvim_buf_get_name(0), false)
	end
end

function M.init()
	vim.api.nvim_create_user_command(
		"MiniFiles",
		minifiles_toggle,
		{ desc = "Open mini.files focused on the current file" }
	)

	require("mappings").register({
		"<leader>e",
		"<cmd>MiniFiles<cr>",
		desc = "Explorer",
	})
end

function M.config()
	local mini_files = require("mini.files")
	local icons = require("icons")

	mini_files.setup({
		options = {
			-- Whether to delete permanently or move into module-specific trash
			permanent_delete = false,
			-- Whether to use for editing directories
			use_as_default_explorer = true,
		},

		-- Module mappings created only inside explorer.
		-- Use `''` (empty string) to not create one.
		mappings = {
			close = "q",
			go_in = "<TAB>",
			go_in_plus = "<C-l>",
			go_out = "H",
			go_out_plus = "<C-h>",
			reset = "<BS>",
			reveal_cwd = "@",
			show_help = "g?",
			synchronize = "s",
			trim_left = "<",
			trim_right = ">",
		},

		windows = {
			-- Maximum number of windows to show side by side
			max_number = math.huge,
			-- Whether to show preview of file/directory under cursor
			preview = true,
			-- Width of focused window
			width_focus = 75,
			-- Width of non-focused window
			width_nofocus = 30,
			-- Width of preview window
			width_preview = 75,
		},
	})

	-- Show/hide dotfiles

	local show_dotfiles = true

	local filter_show = function(_)
		return true
	end

	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end

	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		mini_files.refresh({ content = { filter = new_filter } })
		vim.notify(
			"Dotfiles " .. (show_dotfiles and "shown" or "hidden"),
			vim.log.levels.INFO,
			{ title = "File explorer" }
		)
	end

	-- Splits
	local map_split = function(buf_id, lhs, direction)
		local rhs = function()
			-- Make new window and set it as target
			local cur_target = mini_files.get_explorer_state().target_window
			local new_target = vim.api.nvim_win_call(cur_target, function()
				vim.cmd(direction .. " split")
				return vim.api.nvim_get_current_win()
			end)

			mini_files.set_target_window(new_target)

			mini_files.go_in({ close_on_file = true })
		end

		-- Adding `desc` will result into `show_help` entries
		local desc = "Split " .. direction
		vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			-- Tweak keys to your liking
			vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
			map_split(buf_id, "_", "belowright horizontal")
			map_split(buf_id, "|", "belowright vertical")
			map_split(buf_id, "<C-t>", "tab")
		end,
	})

	-- LSP support when moving/renming files
	vim.api.nvim_create_autocmd("User", {
		desc = "Update imports when files are moved",
		pattern = "MiniFilesActionMove",
		callback = function(event)
			local old_path = event.data.from
			local new_path = event.data.to

			vim.schedule(function()
				-- Get all active LSP clients (compatible with newer Neovim versions)
				local clients = vim.lsp.get_clients()

				for _, client in pairs(clients) do
					-- Check if the client supports willRenameFiles
					if
						client.server_capabilities
						and client.server_capabilities.workspace
						and client.server_capabilities.workspace.fileOperations
						and client.server_capabilities.workspace.fileOperations.willRename
					then
						local params = {
							files = {
								{
									oldUri = vim.uri_from_fname(old_path),
									newUri = vim.uri_from_fname(new_path),
								},
							},
						}

						-- Send the willRenameFiles request to update imports
						client:request("workspace/willRenameFiles", params, function(err, workspace_edit)
							if err then
								vim.notify("LSP rename failed: " .. tostring(err), vim.log.levels.ERROR)
								return
							end

							if workspace_edit then
								-- Apply the workspace edit to update imports
								vim.lsp.util.apply_workspace_edit(workspace_edit, client.offset_encoding)
								vim.notify("Updated imports for moved file", vim.log.levels.INFO)
							end
						end)
					end
				end
			end)
		end,
	})

	-- Git
	-- https://gist.github.com/bassamsdata/eec0a3065152226581f8d4244cce9051#file-notes-md
	local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
	local autocmd = vim.api.nvim_create_autocmd
	local _, MiniFiles = pcall(require, "mini.files")

	-- Cache for git status
	local gitStatusCache = {}
	local cacheTimeout = 2000 -- in milliseconds
	local uv = vim.uv or vim.loop

	local function isSymlink(path)
		local stat = uv.fs_lstat(path)
		return stat and stat.type == "link"
	end

	---@type table<string, {symbol: string, hlGroup: string}>
	---@param status string
	---@return string symbol, string hlGroup
	local function mapSymbols(status, is_symlink)
		local statusMap = {
			[" M"] = { symbol = icons.git.modified, hlGroup = "MiniDiffSignChange" }, -- Modified in the working directory
			["M "] = { symbol = icons.git.modified, hlGroup = "MiniDiffSignChange" }, -- modified in index
			["MM"] = { symbol = icons.git.modified, hlGroup = "MiniDiffSignChange" }, -- modified in both working tree and index
			["A "] = { symbol = icons.git.staged, hlGroup = "MiniDiffSignAdd" }, -- Added to the staging area, new file
			["AA"] = { symbol = icons.git.added, hlGroup = "MiniDiffSignAdd" }, -- file is added in both working tree and index
			["D "] = { symbol = icons.git.unstaged, hlGroup = "MiniDiffSignDelete" }, -- Deleted from the staging area
			["AM"] = { symbol = icons.git.added_and_modified, hlGroup = "MiniDiffSignChange" }, -- added in working tree, modified in index
			["AD"] = { symbol = icons.git.deleted, hlGroup = "MiniDiffSignChange" }, -- Added in the index and deleted in the working directory
			["R "] = { symbol = icons.git.renamed, hlGroup = "MiniDiffSignChange" }, -- Renamed in the index
			["U "] = { symbol = icons.git.unmerged, hlGroup = "MiniDiffSignChange" }, -- Unmerged path
			["UU"] = { symbol = icons.git.unmerged, hlGroup = "MiniDiffSignAdd" }, -- file is unmerged
			["UA"] = { symbol = icons.git.added_and_modified, hlGroup = "MiniDiffSignAdd" }, -- file is unmerged and added in working tree
			["??"] = { symbol = icons.git.untracked, hlGroup = "MiniDiffSignDelete" }, -- Untracked files
			["!!"] = { symbol = icons.git.ignored, hlGroup = "MiniDiffSignChange" }, -- Ignored files
		}

		local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
		local gitSymbol = result.symbol
		local gitHlGroup = result.hlGroup

		local symlinkSymbol = is_symlink and "↩" or ""

		-- Combine symlink symbol with Git status if both exist
		local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
		-- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
		local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup

		return combinedSymbol, combinedHlGroup
	end

	---@param cwd string
	---@param callback function
	---@return nil
	local function fetchGitStatus(cwd, callback)
		local clean_cwd = cwd:gsub("^minifiles://%d+/", "")
		---@param content table
		local function on_exit(content)
			if content.code == 0 then
				callback(content.stdout)
				-- vim.g.content = content.stdout
			end
		end
		---@see vim.system
		vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = clean_cwd }, on_exit)
	end

	---@param buf_id integer
	---@param gitStatusMap table
	---@return nil
	local function updateMiniWithGit(buf_id, gitStatusMap)
		vim.schedule(function()
			local nlines = vim.api.nvim_buf_line_count(buf_id)
			local cwd = vim.fs.root(buf_id, ".git")
			local escapedcwd = cwd and vim.pesc(cwd)
			escapedcwd = vim.fs.normalize(escapedcwd)

			for i = 1, nlines do
				local entry = MiniFiles.get_fs_entry(buf_id, i)
				if not entry then
					break
				end
				local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
				local status = gitStatusMap[relativePath]

				if status then
					local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
					vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
						sign_text = symbol,
						sign_hl_group = hlGroup,
						priority = 2,
					})

					-- This below code is responsible for coloring the text of the items. comment it out if you don't want that
					local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
					-- Find the name position accounting for potential icons
					local nameStartCol = line:find(vim.pesc(entry.name)) or 0

					if nameStartCol > 0 then
						vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
							end_col = nameStartCol + #entry.name - 1,
							hl_group = hlGroup,
						})
					end

					-- if nameStartCol > 0 then
					-- 	vim.api.nvim_buf_add_highlight(
					-- 		buf_id,
					-- 		nsMiniFiles,
					-- 		hlGroup,
					-- 		i - 1,
					-- 		nameStartCol - 1,
					-- 		nameStartCol + #entry.name - 1
					-- 	)
					-- end
				else
				end
			end
		end)
	end

	-- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
	---@param content string
	---@return table
	local function parseGitStatus(content)
		local gitStatusMap = {}
		-- lua match is faster than vim.split (in my experience )
		for line in content:gmatch("[^\r\n]+") do
			local status, filePath = string.match(line, "^(..)%s+(.*)")
			-- Split the file path into parts
			local parts = {}
			for part in filePath:gmatch("[^/]+") do
				table.insert(parts, part)
			end
			-- Start with the root directory
			local currentKey = ""
			for i, part in ipairs(parts) do
				if i > 1 then
					-- Concatenate parts with a separator to create a unique key
					currentKey = currentKey .. "/" .. part
				else
					currentKey = part
				end
				-- If it's the last part, it's a file, so add it with its status
				if i == #parts then
					gitStatusMap[currentKey] = status
				else
					-- If it's not the last part, it's a directory. Check if it exists, if not, add it.
					if not gitStatusMap[currentKey] then
						gitStatusMap[currentKey] = status
					end
				end
			end
		end
		return gitStatusMap
	end

	---@param buf_id integer
	---@return nil
	local function updateGitStatus(buf_id)
		if not vim.fs.root(buf_id, ".git") then
			return
		end
		local cwd = vim.fs.root(buf_id, ".git")
		-- local cwd = vim.fn.expand("%:p:h")
		local currentTime = os.time()

		if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
			updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
		else
			fetchGitStatus(cwd, function(content)
				local gitStatusMap = parseGitStatus(content)
				gitStatusCache[cwd] = {
					time = currentTime,
					statusMap = gitStatusMap,
				}
				updateMiniWithGit(buf_id, gitStatusMap)
			end)
		end
	end

	---@return nil
	local function clearCache()
		gitStatusCache = {}
	end

	local function augroup(name)
		return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
	end

	autocmd("User", {
		group = augroup("start"),
		pattern = "MiniFilesExplorerOpen",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			updateGitStatus(bufnr)
		end,
	})

	autocmd("User", {
		group = augroup("close"),
		pattern = "MiniFilesExplorerClose",
		callback = function()
			clearCache()
		end,
	})

	autocmd("User", {
		group = augroup("update"),
		pattern = "MiniFilesBufferUpdate",
		callback = function(args)
			local bufnr = args.data.buf_id
			local cwd = vim.fs.root(bufnr, ".git")
			if gitStatusCache[cwd] then
				updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
			end
		end,
	})

	-- Create git highlights
	local hls = require("highlights")
	hls.register_hls({
		MiniDiffSignChange = { link = "GitSignsChangeNr" }, -- other: SnacksPickerGitStatusModified
		MiniDiffSignAdd = { link = "GitSignsAddNr" }, -- other: SnacksPickerGitStatusAdded
		MiniDiffSignDelete = { link = "GitSignsDeleteNr" }, -- other: SnacksPickerGitStatusDeleted
	})
end

return M
