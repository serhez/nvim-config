local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
	cmd = { "Telescope" },
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		s = { "<cmd>Telescope live_grep theme=ivy<cr>", "Search text" }, -- Shortcut
		B = {
			l = { "<cmd>Telescope buffers theme=ivy<cr>", "List" }, -- Redundancy
		},
		c = {
			s = {
				name = "Symbols",
				f = { "<cmd>Telescope lsp_document_symbols theme=ivy<cr>", "File" },
				w = { "<cmd>Telescope lsp_workspace_symbols theme=ivy<cr>", "Workspace" },
			},
		},
		f = {
			"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/ theme=ivy<cr>",
			"Find files",
		},
		F = {
			b = { "<cmd>Telescope buffers theme=ivy<cr>", "Buffers" }, -- Redundancy
			C = { "<cmd>Telescope commands theme=ivy<cr>", "Commands" },
			f = {
				"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/ theme=ivy<cr>",
				"Find files",
			}, -- Redundancy
			F = {
				"<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/ theme=ivy<cr>",
				"Files (+ignored)",
			},
			m = { "<cmd>Telescope marks theme=ivy<cr>", "Marks" },
			M = { "<cmd>Telescope man_pages theme=ivy<cr>", "Man pages" },
			r = { "<cmd>Telescope oldfiles theme=ivy<cr>", "Recent files" },
			t = { "<cmd>Telescope live_grep theme=ivy<cr>", "Text" },
		},
		g = {
			l = {
				b = { "<cmd>Telescope git_branches theme=ivy<cr>", "Branches" },
				s = { "<cmd>Telescope git_stash theme=ivy<cr>", "Stashes" },
			},
		},
	})
end

function M.config()
	local icons = require("icons")
	local actions = require("telescope.actions")
	local previewers = require("telescope.previewers")

	require("telescope").setup({
		defaults = {
			prompt_prefix = " " .. icons.lupa .. " ",
			prompt_title = false,
			results_title = false,
			preview_title = false,
			dynamic_preview_title = false,
			selection_caret = " " .. icons.arrow.right_upper_curved .. " ",
			entry_prefix = "   ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			layout_strategy = "vertical",
			layout_config = {
				width = 0.8,
				height = 0.9,
				anchor = "center",
				prompt_position = "top",
				preview_cutoff = 1,
				horizontal = { mirror = true },
				vertical = { mirror = true },
			},
			file_ignore_patterns = {},
			path_display = { "truncate" },
			winblend = 0,
			border = false,
			borderchars = icons.border.straight,
			color_devicons = true,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			file_previewer = previewers.vim_buffer_cat.new,
			grep_previewer = previewers.vim_buffer_vimgrep.new,
			qflist_previewer = previewers.vim_buffer_qflist.new,

			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--trim",
			},

			mappings = {
				i = {
					["<S-esc>"] = actions.close,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-s>"] = actions.toggle_selection,
					["<C-a>"] = actions.toggle_all,
					["<tab>"] = actions.toggle_selection + actions.move_selection_next,
					["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<CR>"] = actions.select_default + actions.center,
				},
				n = {
					["<esc>"] = actions.close,
					["<S-esc>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-s>"] = actions.toggle_selection,
					["<C-a>"] = actions.toggle_all,
					["<tab>"] = actions.toggle_selection + actions.move_selection_next,
					["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				},
			},
		},

		pickers = {
			find_files = {
				theme = "ivy",
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
			},
		},

		extensions = {
			file_browser = {
				theme = "ivy",
				hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
			},
			fzf = {
				theme = "ivy",
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			noice = {
				theme = "ivy",
			},
			undo = {
				theme = "ivy",
				use_delta = true,
				side_by_side = false,
			},
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		TelescopeBorder = common_hls.no_border_alt,
		TelescopePromptBorder = common_hls.no_border_alt,
		TelescopeResultsBorder = common_hls.no_border_alt,
		TelescopePreviewBorder = common_hls.no_border_statusline,
		TelescopeNormal = { fg = c.fg, bg = c.cursor_line_bg },
		TelescopePromptNormal = { fg = c.fg, bg = c.cursor_line_bg },
		TelescopePromptPrefix = { fg = c.cyan, bg = c.cursor_line_bg },
		TelescopePromptCounter = { fg = c.fg, bg = c.cursor_line_bg },
		TelescopePromptTitle = { fg = c.bg, bg = c.blue },
		TelescopeResultsNormal = { fg = c.fg, bg = c.cursor_line_bg },
		TelescopeResultsTitle = { fg = c.bg, bg = c.red },
		TelescopePreviewNormal = { fg = c.fg, bg = c.statusline_bg },
		TelescopePreviewTitle = { fg = c.bg, bg = c.green },
		TelescopeSelection = { default = true, link = "Visual" },
		TelescopeSelectionCaret = { default = true, link = "Visual" },
		TelescopeMultiSelection = { default = true, link = "Visual" },
	})
end

return M
