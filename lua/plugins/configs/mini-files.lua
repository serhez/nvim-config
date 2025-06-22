-- TODO: give another try
local M = {
	"echasnovski/mini.files",
	version = false,
	enabled = false,
}

function M.init()
	vim.api.nvim_create_user_command(
		"MiniFiles",
		"lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)",
		{ desc = "Open mini.files focused on the current file" }
	)

	require("mappings").register({
		"<leader>E",
		"<cmd>MiniFiles<cr>",
		desc = "Explorer (dev)",
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
			go_in_plus = "l",
			go_out = "H",
			go_out_plus = "h",
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
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			-- Tweak left-hand side of mapping to your liking
			vim.keymap.set("n", ".", toggle_dotfiles, { buffer = buf_id })
		end,
	})

	-- Splits

	local map_split = function(buf_id, lhs, direction)
		local rhs = function()
			-- Make new window and set it as target
			local new_target_window
			vim.api.nvim_win_call(mini_files.get_target_window(), function()
				vim.cmd(direction .. " split")
				new_target_window = vim.api.nvim_get_current_win()
			end)

			mini_files.set_target_window(new_target_window)
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
			map_split(buf_id, "_", "belowright horizontal")
			map_split(buf_id, "|", "belowright vertical")
		end,
	})

	-- Git
	-- https://gist.github.com/bassamsdata/eec0a3065152226581f8d4244cce9051#file-notes-md
	local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
	local autocmd = vim.api.nvim_create_autocmd
	local _, MiniFiles = pcall(require, "mini.files")

	-- Cache for git status
	local gitStatusCache = {}
	local cacheTimeout = 2000 -- Cache timeout in milliseconds

	local function mapSymbols(status)
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
		return result.symbol, result.hlGroup
	end

	---@param cwd string
	---@param callback function
	local function fetchGitStatus(cwd, callback)
		local function on_exit(content)
			if content.code == 0 then
				callback(content.stdout)
				vim.g.content = content.stdout
			end
		end
		vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = cwd }, on_exit)
	end

	local function escapePattern(str)
		return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
	end

	local function updateMiniWithGit(buf_id, gitStatusMap)
		vim.schedule(function()
			local nlines = vim.api.nvim_buf_line_count(buf_id)
			local cwd = vim.fn.getcwd()
			local escapedcwd = escapePattern(cwd)
			if vim.fn.has("win32") == 1 then
				escapedcwd = escapedcwd:gsub("\\", "/")
			end

			for i = 1, nlines do
				local entry = MiniFiles.get_fs_entry(buf_id, i)
				if not entry then
					break
				end
				local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
				local status = gitStatusMap[relativePath]

				if status then
					local symbol, hlGroup = mapSymbols(status)
					vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
						sign_text = symbol,
						sign_hl_group = hlGroup,
						priority = 2,
					})
				else
				end
			end
		end)
	end

	local function is_valid_git_repo()
		if vim.fn.isdirectory(".git") == 0 then
			return false
		end
		return true
	end

	-- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
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

	local function updateGitStatus(buf_id)
		if not is_valid_git_repo() then
			return
		end
		local cwd = vim.fn.expand("%:p:h")
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
		callback = function(sii)
			local bufnr = sii.data.buf_id
			local cwd = vim.fn.expand("%:p:h")
			if gitStatusCache[cwd] then
				updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
			end
		end,
	})
end

return M
