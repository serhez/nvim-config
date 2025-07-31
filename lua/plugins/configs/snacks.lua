local icons = require("icons")

local M = {
	"folke/snacks.nvim",
	lazy = "false",
	opts = {
		bigfile = { enabled = true },
		-- image = { enabled = true }, -- NOTE: works like shit for now
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
				duration = {
					step = 20, -- ms per step
					total = 300, -- maximum duration
				},
			},
			filter = function(buf)
				return vim.g.snacks_indent ~= false
					or vim.b[buf].snacks_indent ~= false
					or vim.bo[buf].buftype == "" ~= false
					or vim.bo[buf].ft == "" ~= false
					or vim.bo[buf].ft == "qf" ~= false
					or vim.bo[buf].ft == "help" ~= false
					or vim.bo[buf].ft == "dapui_scopes" ~= false
					or vim.bo[buf].ft == "dapui_watches" ~= false
					or vim.bo[buf].ft == "dapui_stacks" ~= false
					or vim.bo[buf].ft == "dapui_breakpoints" ~= false
					or vim.bo[buf].ft == "dapui_console" ~= false
					or vim.bo[buf].ft == "dap-repl" ~= false
					or vim.bo[buf].ft == "harpoon" ~= false
					or vim.bo[buf].ft == "dropbar_menu" ~= false
					or vim.bo[buf].ft == "glow" ~= false
					or vim.bo[buf].ft == "aerial" ~= false
					or vim.bo[buf].ft == "dashboard" ~= false
					or vim.bo[buf].ft == "lspinfo" ~= false
					or vim.bo[buf].ft == "lspsagafinder" ~= false
					or vim.bo[buf].ft == "packer" ~= false
					or vim.bo[buf].ft == "checkhealth" ~= false
					or vim.bo[buf].ft == "man" ~= false
					or vim.bo[buf].ft == "mason" ~= false
					or vim.bo[buf].ft == "NvimTree" ~= false
					or vim.bo[buf].ft == "neo-tree" ~= false
					or vim.bo[buf].ft == "plugin" ~= false
					or vim.bo[buf].ft == "lazy" ~= false
					or vim.bo[buf].ft == "TelescopePrompt" ~= false
					or vim.bo[buf].ft == "alpha" ~= false
					or vim.bo[buf].ft == "toggleterm" ~= false
					or vim.bo[buf].ft == "sagafinder" ~= false
					or vim.bo[buf].ft == "sagaoutline" ~= false
					or vim.bo[buf].ft == "better_term" ~= false
					or vim.bo[buf].ft == "fugitiveblame" ~= false
					or vim.bo[buf].ft == "Trouble" ~= false
					or vim.bo[buf].ft == "Outline" ~= false
					or vim.bo[buf].ft == "OutlineHelp" ~= false
					or vim.bo[buf].ft == "starter" ~= false
					or vim.bo[buf].ft == "NeogitPopup" ~= false
					or vim.bo[buf].ft == "NeogitStatus" ~= false
					or vim.bo[buf].ft == "DiffviewFiles" ~= false
					or vim.bo[buf].ft == "DiffviewFileHistory" ~= false
					or vim.bo[buf].ft == "DressingInput" ~= false
					or vim.bo[buf].ft == "spectre_panel" ~= false
					or vim.bo[buf].ft == "zsh" ~= false
					or vim.bo[buf].ft == "vuffers" ~= false
					or vim.bo[buf].ft == "oil" ~= false
					or vim.bo[buf].ft == "oil_preview" ~= false
					or vim.bo[buf].ft == "NeogitConsole" ~= false
					or vim.bo[buf].ft == "text" ~= false
					or vim.bo[buf].ft == "AvanteInput" ~= false
					or vim.bo[buf].ft == "buffer_manager" ~= false
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
				snacks.picker.smart()
			end,
			desc = "Find files",
		},
		{
			"<leader>t",
			function()
				snacks.picker.explorer()
			end,
			desc = "File tree",
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
			"<leader>Eu",
			function()
				snacks.picker.undo()
			end,
			desc = "Undo tree",
		},

		-- List
		{
			"<leader>Ec",
			function()
				snacks.picker.commands()
			end,
			desc = "Commands",
		},
		-- { "<leader>lj", "<cmd>Telescope jsonfly theme=ivy<cr>", desc = "JSON keys" },
		{
			"<leader>Em",
			function()
				snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>Em",
			function()
				snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>EM",
			function()
				snacks.picker.man()
			end,
			desc = "Man pages",
		},
		{
			"<leader>uH",
			function()
				snacks.picker.highlights()
			end,
			desc = "Highlight list",
		},
		{
			"<leader>ui",
			function()
				snacks.picker.icons()
			end,
			desc = "Icons list",
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
	})
end

return M
