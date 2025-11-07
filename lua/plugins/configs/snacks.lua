local icons = require("icons")

local fff_picker = {}

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

fff_picker.state = {}

function fff_picker.finder(_, ctx)
	local file_picker = require("fff.file_picker")

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

	local fff_result = file_picker.search_files(ctx.filter.search, 100, 4, fff_picker.state.current_file_cache, false)

	local items = {}
	for _, fff_item in ipairs(fff_result) do
		local item = {
			text = fff_item.name,
			file = fff_item.path,
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
	local file_picker = require("fff.file_picker")
	if not file_picker.is_initialized() then
		local setup_success = file_picker.setup()
		if not setup_success then
			vim.notify("Failed to initialize file picker", vim.log.levels.ERROR)
		end
	end
	require("snacks").picker({
		title = "Files",
		finder = fff_picker.finder,
		on_close = on_close,
		format = format,
		live = true,
	})
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
				enabled = vim.fn.has("nvim-0.10") == 1,
				-- enabled = false,
				duration = {
					step = 10, -- ms per step
					total = 500, -- maximum duration
				},
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
			layout = {
				cycle = true, -- go to top when reaching bottom and vice versa
				preset = function()
					return vim.o.columns >= 120 and "ivy" or "vscode"
				end,
				-- Improve the presets
				layout = {
					height = 0.9,
					backdrop = true,
					title_pos = "center",
				},
			},
			matcher = {
				fuzzy = true, -- use fuzzy matching
				smartcase = true, -- use smartcase
				ignorecase = true, -- use ignorecase
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = false, -- give bonus for matching files in the cwd
				frecency = true, -- frecency bonus
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
					show_always = false, -- only show the selected column when there are multiple selections
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
				snacks.picker.grep()
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
		{ "<leader>gh", group = "GitHub" },
		{ "<leader>ghi", group = "Issues" },
		{ "<leader>ghp", group = "Pull requests" },
		{
			"<leader>ghio",
			function()
				snacks.picker.gh_issue()
			end,
			desc = "Open",
		},
		{
			"<leader>ghia",
			function()
				snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "All",
		},
		{
			"<leader>ghpo",
			function()
				snacks.picker.gh_pr()
			end,
			desc = "Open",
		},
		{
			"<leader>ghpa",
			function()
				snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "All",
		},
	})
end

return M
