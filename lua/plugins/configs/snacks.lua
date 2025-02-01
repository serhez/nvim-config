local icons = require("icons")

local M = {
	"folke/snacks.nvim",
	opts = {
		bigfile = {},
		picker = {
			prompt = " " .. icons.arrow.right_short_thick .. " ",
			layout = {
				cycle = true, -- go to top when reaching bottom and vice versa
				preset = function()
					return vim.o.columns >= 120 and "ivy" or "vscode"
				end,
				-- Improve the presets
				layout = {
					height = 0.66,
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
						["_"] = { "edit_split", mode = { "i", "n" } },
						["|"] = { "edit_vsplit", mode = { "i", "n" } },
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
	event = "BufReadPre",
}

function M.init()
	local snacks = require("snacks")

	require("mappings").register({
		-- Files
		{
			"<leader>f",
			function()
				snacks.picker.files()
			end,
			desc = "Find files",
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
			"<leader>ca",
			function()
				vim.lsp.buf.code_action()
			end,
			desc = "Actions",
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
			"<leader>lC",
			function()
				snacks.picker.commands()
			end,
			desc = "Commands",
		},
		-- { "<leader>lj", "<cmd>Telescope jsonfly theme=ivy<cr>", desc = "JSON keys" },
		{
			"<leader>lm",
			function()
				snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>lM",
			function()
				snacks.picker.man()
			end,
			desc = "Man pages",
		},
		{
			"<leader>lh",
			function()
				snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>li",
			function()
				snacks.picker.icons()
			end,
			desc = "Icons",
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
