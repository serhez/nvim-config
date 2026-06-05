local icons = require("icons")

local fff_picker = {}
local fff_grep_picker = {}

local function is_overleaf_buffer()
	local ok, overleaf = pcall(require, "overleaf")
	return ok and overleaf.is_overleaf_context(0) or false
end

local function try_overleaf_picker(kind)
	if not is_overleaf_buffer() then
		return false
	end

	local ok, overleaf = pcall(require, "overleaf")
	if ok then
		if kind == "files" then
			overleaf.files()
		elseif kind == "grep" then
			overleaf.search()
		end
	else
		vim.cmd(kind == "files" and "Overleaf files" or "Overleaf search")
	end

	return true
end

local function try_sshfs_live_picker(method)
	local utils = require("utils")
	if not (utils.is_slow_fs_buf(0) or utils.is_slow_fs_path(vim.fn.getcwd())) then
		return false
	end

	local ok, sshfs = pcall(require, "sshfs")
	if not ok or not sshfs.has_active or not sshfs.has_active() then
		return false
	end

	if type(sshfs[method]) ~= "function" then
		return false
	end

	sshfs[method]()
	return true
end

local function route(handlers)
	local ok, router = pcall(require, "editr.router")
	if ok then
		return router.first(handlers)
	end

	for _, handler in ipairs(handlers) do
		if handler() then
			return true
		end
	end
	return false
end

local staged_status = {
	staged_new = true,
	staged_modified = true,
	staged_deleted = true,
	renamed = true,
}

local status_map = {
	untracked = "untracked",
	modified = "modified",
	deleted = "deleted",
	renamed = "renamed",
	staged_new = "added",
	staged_modified = "modified",
	staged_deleted = "deleted",
	ignored = "ignored",
	-- clean = "",
	-- clear = "",
	unknown = "untracked",
}

local function ensure_fff_file_picker()
	local file_picker = require("fff.file_picker")
	if file_picker.is_initialized() then
		return true
	end

	local setup_success = file_picker.setup()
	if not setup_success then
		vim.notify("Failed to initialize fff file picker", vim.log.levels.ERROR)
		return false
	end

	return true
end

fff_picker.state = {}

function fff_picker.finder(_, ctx)
	local file_picker = require("fff.file_picker")
	local base_path = require("fff.conf").get().base_path

	if not fff_picker.state.current_file_cache then
		local current_buf = vim.api.nvim_get_current_buf()
		if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
			local current_file = vim.api.nvim_buf_get_name(current_buf)
			if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
				fff_picker.state.current_file_cache = current_file
			else
				fff_picker.state.current_file_cache = nil
			end
		end
	end

	local fff_result = file_picker.search_files(ctx.filter.search, fff_picker.state.current_file_cache, 100, 4, nil)

	local items = {}
	for _, fff_item in ipairs(fff_result) do
		local file = fff_item.relative_path or fff_item.path
		local item = {
			text = fff_item.name or file,
			file = file,
			cwd = base_path,
			score = fff_item.total_frecency_score,
			status = status_map[fff_item.git_status] and {
				status = status_map[fff_item.git_status],
				staged = staged_status[fff_item.git_status] or false,
				unmerged = fff_item.git_status == "unmerged",
			},
		}
		items[#items + 1] = item
	end

	return items
end

local function on_close()
	fff_picker.state.current_file_cache = nil
end

local function format_file_git_status(item, picker)
	local ret = {}
	local status = item.status

	local hl = "SnacksPickerGitStatus"
	if status.unmerged then
		hl = "SnacksPickerGitStatusUnmerged"
	elseif status.staged then
		hl = "SnacksPickerGitStatusStaged"
	else
		hl = "SnacksPickerGitStatus" .. status.status:sub(1, 1):upper() .. status.status:sub(2)
	end

	local icon = picker.opts.icons.git[status.status]
	if status.staged then
		icon = picker.opts.icons.git.staged
	end

	ret[#ret + 1] = { icon, hl }
	ret[#ret + 1] = { " ", virtual = true }
	return ret
end

local function format(item, picker)
	local ret = {}

	if item.label then
		ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
		ret[#ret + 1] = { " ", virtual = true }
	end

	if item.status then
		vim.list_extend(ret, format_file_git_status(item, picker))
	else
		ret[#ret + 1] = { "  ", virtual = true }
	end

	vim.list_extend(ret, require("snacks.picker.format").filename(item, picker))

	if item.line then
		require("snacks").picker.highlight.format(item, item.line, ret)
		table.insert(ret, { " " })
	end
	return ret
end

function fff_picker.picker()
	if not ensure_fff_file_picker() then
		return false
	end

	require("snacks").picker({
		title = "Files",
		finder = fff_picker.finder,
		on_close = on_close,
		format = format,
		live = true,
	})
	return true
end

fff_grep_picker.state = {}

function fff_grep_picker.finder(_, ctx)
	local query = ((ctx or {}).filter or {}).search or ""
	fff_grep_picker.state.last_query = query

	if query == "" then
		return {}
	end

	local ok, grep = pcall(require, "fff.grep")
	if not ok then
		vim.notify("Failed to load fff grep: " .. tostring(grep), vim.log.levels.ERROR)
		return {}
	end

	local conf = require("fff.conf").get()
	local ok_search, fff_result = pcall(grep.search, query, 0, 100, conf.grep or {}, "plain")
	if not ok_search then
		vim.notify("Failed to search text with fff: " .. tostring(fff_result), vim.log.levels.ERROR)
		return {}
	end

	local items = {}
	for _, fff_item in ipairs(fff_result.items or {}) do
		local file = fff_item.relative_path or fff_item.path
		if file then
			local line_number = fff_item.line_number or 1
			local col = fff_item.col or 0
			local line = fff_item.line_content or ""
			local location = ("%s:%d:%d"):format(file, line_number, col + 1)

			items[#items + 1] = {
				text = location .. " " .. line,
				file = file,
				cwd = conf.base_path,
				line = line,
				pos = { line_number, col },
				search = query,
				score = fff_item.fuzzy_score or fff_item.total_frecency_score,
				status = status_map[fff_item.git_status] and {
					status = status_map[fff_item.git_status],
					staged = staged_status[fff_item.git_status] or false,
					unmerged = fff_item.git_status == "unmerged",
				},
			}
		end
	end

	return items
end

local function on_grep_close()
	local query = fff_grep_picker.state.last_query
	fff_grep_picker.state.last_query = nil

	if not query or query == "" then
		return
	end

	local ok, fuzzy = pcall(require, "fff.fuzzy")
	if ok then
		pcall(fuzzy.track_grep_query, query)
	end
end

function fff_grep_picker.picker()
	if not ensure_fff_file_picker() then
		return false
	end

	require("snacks").picker({
		title = "Grep",
		finder = fff_grep_picker.finder,
		on_close = on_grep_close,
		format = format,
		live = true,
	})
	return true
end

local M = {
	"folke/snacks.nvim",
	lazy = "false",
	opts = {
		bigfile = { enabled = true },
		-- image = { enabled = true }, -- NOTE: works like shit for now
		gh = {},
		indent = {
			indent = {
				priority = 1,
				enabled = true,
			},
			scope = {
				enabled = true,
			},
			chunk = {
				enabled = true,
				char = {
					arrow = icons.bar.horizontal_thin,
				},
			},
			animate = {
				-- enabled = vim.fn.has("nvim-0.10") == 1,
				enabled = false,
				-- duration = {
				-- 	step = 10, -- ms per step
				-- 	total = 500, -- maximum duration
				-- },
			},
			filter = function(buf)
				return vim.g.snacks_indent ~= false
					and vim.b[buf].snacks_indent ~= false
					and vim.bo[buf].ft ~= ""
					and vim.bo[buf].ft ~= "wk"
					and vim.bo[buf].ft ~= "qf"
					and vim.bo[buf].ft ~= "help"
					and vim.bo[buf].ft ~= "dapui_scopes"
					and vim.bo[buf].ft ~= "dapui_watches"
					and vim.bo[buf].ft ~= "dapui_stacks"
					and vim.bo[buf].ft ~= "dapui_breakpoints"
					and vim.bo[buf].ft ~= "dapui_console"
					and vim.bo[buf].ft ~= "dap-repl"
					and vim.bo[buf].ft ~= "harpoon"
					and vim.bo[buf].ft ~= "dropbar_menu"
					and vim.bo[buf].ft ~= "glow"
					and vim.bo[buf].ft ~= "aerial"
					and vim.bo[buf].ft ~= "dashboard"
					and vim.bo[buf].ft ~= "lspinfo"
					and vim.bo[buf].ft ~= "lspsagafinder"
					and vim.bo[buf].ft ~= "packer"
					and vim.bo[buf].ft ~= "checkhealth"
					and vim.bo[buf].ft ~= "man"
					and vim.bo[buf].ft ~= "mason"
					and vim.bo[buf].ft ~= "noice"
					and vim.bo[buf].ft ~= "NvimTree"
					and vim.bo[buf].ft ~= "neo-tree"
					and vim.bo[buf].ft ~= "plugin"
					and vim.bo[buf].ft ~= "lazy"
					and vim.bo[buf].ft ~= "TelescopePrompt"
					and vim.bo[buf].ft ~= "alpha"
					and vim.bo[buf].ft ~= "toggleterm"
					and vim.bo[buf].ft ~= "sagafinder"
					and vim.bo[buf].ft ~= "sagaoutline"
					and vim.bo[buf].ft ~= "better_term"
					and vim.bo[buf].ft ~= "fugitiveblame"
					and vim.bo[buf].ft ~= "Trouble"
					and vim.bo[buf].ft ~= "Outline"
					and vim.bo[buf].ft ~= "OutlineHelp"
					and vim.bo[buf].ft ~= "starter"
					and vim.bo[buf].ft ~= "NeogitPopup"
					and vim.bo[buf].ft ~= "NeogitStatus"
					and vim.bo[buf].ft ~= "DiffviewFiles"
					and vim.bo[buf].ft ~= "DiffviewFileHistory"
					and vim.bo[buf].ft ~= "DressingInput"
					and vim.bo[buf].ft ~= "spectre_panel"
					and vim.bo[buf].ft ~= "zsh"
					and vim.bo[buf].ft ~= "vuffers"
					and vim.bo[buf].ft ~= "oil"
					and vim.bo[buf].ft ~= "oil_preview"
					and vim.bo[buf].ft ~= "canola"
					and vim.bo[buf].ft ~= "canola_preview"
					and vim.bo[buf].ft ~= "NeogitConsole"
					and vim.bo[buf].ft ~= "text"
					and vim.bo[buf].ft ~= "AvanteInput"
					and vim.bo[buf].ft ~= "buffer_manager"
					and vim.bo[buf].ft ~= "snacks_picker_list"
					and vim.bo[buf].ft ~= "snacks_picker_input"
					and vim.bo[buf].ft ~= "markdown"
			end,
		},
		picker = {
			prompt = "   " .. icons.arrow.right_short_thick .. " ",
			-- layout = {
			-- 	cycle = true, -- go to top when reaching bottom and vice versa
			-- preset = function()
			-- 	return vim.o.columns >= 120 and "ivy" or "vscode"
			-- end,
			-- -- Improve the presets
			-- layout = {
			-- 	height = 0.9,
			-- 	backdrop = true,
			-- 	title_pos = "center",
			-- },
			layout = function()
				if vim.o.columns >= 120 then
					return {
						cycle = true,
						layout = {
							box = "vertical",
							backdrop = true,
							row = -1,
							width = 0,
							height = 0.9,
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{
									win = "preview",
									title = "{preview}",
									width = 0.4,
									border = "left",
								},
							},
						},
					}
				else
					return {
						cycle = true,
						hidden = { "preview" },
						layout = {
							box = "vertical",
							backdrop = true,
							row = 1,
							width = 0.8,
							height = 0.9,
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "center",
							{
								win = "input",
								height = 1,
								border = "bottom",
							},
							{ win = "list", border = "hpad" },
						},
					}
				end
			end,
			-- },
			matcher = {
				fuzzy = true, -- use fuzzy matching
				smartcase = true, -- use smartcase
				ignorecase = true, -- use ignorecase
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = true, -- give bonus for matching files in the cwd
				frecency = true, -- frecency bonus
				history_bonus = true,
			},
			jump = {
				jumplist = true, -- save the current position in the jumplist
				tagstack = true, -- save the current position in the tagstack
				reuse_win = true, -- reuse an existing window if the buffer is already open
				close = true, -- close the picker when jumping/editing to a location (defaults to true)
				match = false, -- jump to the first match position. (useful for `lines`)
			},
			formatters = {
				text = {
					ft = nil, ---@type string? filetype for highlighting
				},
				file = {
					filename_first = true, -- display filename before the file path
					truncate = 40, -- truncate the file path to (roughly) this length
					filename_only = false, -- only show the filename
				},
				selected = {
					show_always = true, -- only show the selected column when there are multiple selections
					unselected = true, -- use the unselected icon for unselected items
				},
				severity = {
					icons = true, -- show severity icons
					level = false, -- show severity level
				},
			},
			win = {
				-- input window
				input = {
					keys = {
						["_"] = { "edit_split", mode = { "n" } },
						["|"] = { "edit_vsplit", mode = { "n" } },
						["<c-s>"] = { "edit_split", mode = { "i" } },
						["<c-v>"] = { "edit_vsplit", mode = { "i" } },
						["<c-l>"] = { "loclist", mode = { "n", "i" } },
						["<C-w>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
					},
				},
				list = {
					keys = {
						["_"] = { "edit_split" },
						["|"] = { "edit_vsplit" },
						["<c-l>"] = { "loclist" },
						["<C-w>"] = { { "pick_win", "jump" } },
					},
					wo = {
						statuscolumn = " ",
						signcolumn = "no",
						-- foldcolumn = "no",
					},
				},
				preview = {
					wo = {
						statuscolumn = " ",
						signcolumn = "no",
						-- foldcolumn = "no",
					},
				},
			},
			icons = {
				git = {
					enabled = true, -- show git icons
					commit = icons.git.commit, -- used by git log
					staged = icons.git.staged,
					added = icons.git.added,
					deleted = icons.git.deleted,
					ignored = icons.git.ignored .. " ",
					modified = icons.git.modified,
					renamed = icons.git.renamed,
					unmerged = icons.git.unmerged .. " ",
					untracked = icons.git.untracked,
				},
				diagnostics = {
					Error = icons.diagnostics.error .. " ",
					Warn = icons.diagnostics.warning .. " ",
					Hint = icons.diagnostics.hint .. " ",
					Info = icons.diagnostics.info .. " ",
				},
			},
		},
	},
}

function M.init()
	local snacks = require("snacks")

	require("mappings").register({
		-- Files
		{
			"<leader>f",
			function()
				local ok, router = pcall(require, "editr.router")
				local editr_files = ok and router.editr("files") or function()
					return false
				end
				if route({
					function()
						return try_overleaf_picker("files")
					end,
					editr_files,
					function()
						return try_sshfs_live_picker("live_find")
					end,
				}) then
					return
				end
				fff_picker.picker()
			end,
			desc = "Find files",
		},
		{
			"<leader>E",
			function()
				snacks.picker.explorer()
			end,
			desc = "Explorer (tree)",
		},

		-- Text
		{
			"<leader>s",
			function()
				local ok, router = pcall(require, "editr.router")
				local editr_grep = ok and router.editr("grep") or function()
					return false
				end
				if route({
					function()
						return try_overleaf_picker("grep")
					end,
					editr_grep,
					function()
						return try_sshfs_live_picker("live_grep")
					end,
				}) then
					return
				end
				if not fff_grep_picker.picker() then
					snacks.picker.grep()
				end
			end,
			desc = "Search text",
		},

		-- Buffers
		{
			"<leader>bl",
			function()
				snacks.picker.buffers()
			end,
			desc = "List",
		},

		-- Code
		{
			"<leader>cs",
			function()
				snacks.picker.lsp_symbols()
			end,
			desc = "Symbols",
		},
		{
			"<leader>cS",
			function()
				snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Symbols (workspace)",
		},
		{
			"<leader>u",
			function()
				snacks.picker.undo()
			end,
			desc = "Undo tree",
		},

		-- List
		{
			"<leader>kH",
			function()
				snacks.picker.highlights()
			end,
			desc = "Highlight list",
		},
		{
			"<leader>ki",
			function()
				snacks.picker.icons()
			end,
			desc = "Icons list",
		},
		{
			"<leader>kl",
			function()
				snacks.picker.lsp_config()
			end,
			desc = "LSP servers",
		},

		-- Git
		{
			"<leader>gb",
			function()
				snacks.picker.git_branches()
			end,
			desc = "Branches",
		},
		{
			"<leader>gs",
			function()
				snacks.picker.git_stash()
			end,
			desc = "Stashes",
		},

		-- GitHub
		{ "<leader>gH", group = "GitHub" },
		{ "<leader>gHi", group = "Issues" },
		{ "<leader>gHp", group = "Pull requests" },
		{
			"<leader>gHio",
			function()
				snacks.picker.gh_issue()
			end,
			desc = "Open",
		},
		{
			"<leader>gHia",
			function()
				snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "All",
		},
		{
			"<leader>gHpo",
			function()
				snacks.picker.gh_pr()
			end,
			desc = "Open",
		},
		{
			"<leader>gHpa",
			function()
				snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "All",
		},
	})
end

return M
