local icons = require("icons")
local mappings = require("mappings")
local hls = require("highlights")

local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
	cmd = { "Telescope" },
}

function M.init()
	mappings.register_normal({
		s = { "<cmd>Telescope live_grep<cr>", "Search text" }, -- Shortcut
		S = { "<cmd>Telescope grep_string search=<cr>", "Search text (fuzzy)" }, -- Shortcut
		b = {
			l = { "<cmd>Telescope buffers<cr>", "List" }, -- Redundancy
		},
		c = {
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols (file)" },
			S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Symbols (project)" },
		},
		f = {
			b = { "<cmd>Telescope buffers<cr>", "Buffers" }, -- Redundancy
			c = { "<cmd>Telescope commands<cr>", "Commands" },
			f = {
				"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/<cr>",
				"Files",
			},
			F = {
				"<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/<cr>",
				"Files (+ignored)",
			},
			m = { "<cmd>Telescope marks<cr>", "Marks" },
			M = { "<cmd>Telescope man_pages<cr>", "Man pages" },
			r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
			t = { "<cmd>Telescope live_grep<cr>", "Text" },
			T = { "<cmd>Telescope grep_string search=<cr>", "Text (fuzzy)" },
		},
		g = {
			l = {
				b = { "<cmd>Telescope git_branches<cr>", "Branches" },
				s = { "<cmd>Telescope git_stash<cr>", "Stashes" },
			},
		},
	})
end

function M.config()
	local actions = require("telescope.actions")
	local previewers = require("telescope.previewers")

	require("telescope").setup({
		defaults = {
			prompt_prefix = icons.single_space .. icons.lupa .. icons.single_space,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
			selection_caret = icons.single_space .. icons.arrow.right_upper_curved .. icons.single_space,
			entry_prefix = icons.triple_space,
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
				horizontal = { mirror = false },
				vertical = { mirror = false },
			},
			file_ignore_patterns = {},
			path_display = { "truncate" },
			winblend = 0,
			border = true,
			borderchars = icons.borders.straight,
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
					["<esc>"] = actions.close,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<tab>"] = actions.toggle_selection + actions.move_selection_next,
					["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<CR>"] = actions.select_default + actions.center,
				},
				n = {
					["<esc>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<tab>"] = actions.toggle_selection + actions.move_selection_next,
					["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				},
			},
		},

		pickers = {
			find_files = {
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
			},
		},

		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			noice = {},
		},
	})

	require("telescope").load_extension("fzf")

	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		TelescopeBorder = common_hls.border,
		TelescopePromptBorder = common_hls.border,
		TelescopeResultsBorder = common_hls.border,
		TelescopePreviewBorder = common_hls.border,
		TelescopeNormal = { fg = c.fg, bg = c.statusline_bg },
		TelescopePromptNormal = { fg = c.fg, bg = c.statusline_bg },
		TelescopePromptPrefix = { fg = c.cyan, bg = c.statusline_bg },
		TelescopePromptCounter = { fg = c.fg, bg = c.statusline_bg },
		TelescopeSelection = { default = true, link = "Visual" },
		TelescopeSelectionCaret = { default = true, link = "Visual" },
		TelescopeMultiSelection = { default = true, link = "Visual" },
	})
end

return M
