local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
		"Myzel394/jsonfly.nvim",
	},
	cmd = { "Telescope" },
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	require("mappings").register({
		{ "<leader>s", "<cmd>Telescope grep_string theme=ivy search=<cr>", desc = "Search text" }, -- Shortcut

		-- Buffers
		-- { "<leader>bl", "<cmd>Telescope buffers theme=ivy<cr>", desc = "List" }, -- handled by hbac

		-- Code
		{ "<leader>cs", "<cmd>Telescope lsp_document_symbols theme=ivy<cr>", desc = "Symbols (buffer)" },
		{ "<leader>cS", "<cmd>Telescope lsp_workspace_symbols theme=ivy<cr>", desc = "Symbols (workspace)" },

		-- List
		{ "<leader>lb", "<cmd>Telescope buffers theme=ivy<cr>", desc = "Buffers" }, -- Redundancy
		{ "<leader>lC", "<cmd>Telescope commands theme=ivy<cr>", desc = "Commands" },
		{
			"<leader>lf",
			"<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/ theme=ivy<cr>",
			desc = "Files (+ignored)",
		},
		{ "<leader>lj", "<cmd>Telescope jsonfly theme=ivy<cr>", desc = "JSON keys" },
		{ "<leader>lm", "<cmd>Telescope marks theme=ivy<cr>", desc = "Marks" },
		{ "<leader>lM", "<cmd>Telescope man_pages theme=ivy<cr>", desc = "Man pages" },

		-- Git
		{ "<leader>gb", "<cmd>Telescope git_branches theme=ivy<cr>", desc = "Branches" },
		{ "<leader>gs", "<cmd>Telescope git_stash theme=ivy<cr>", desc = "Stashes" },
	})
end

function M.config()
	local icons = require("icons")

	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local previewers = require("telescope.previewers")

	local custom_actions = require("telescope.actions.mt").transform_mod({
		-- `trouble` integration
		open_trouble_qflist = function(_)
			require("trouble").open({ mode = "qflist" })
		end,
		open_trouble_loclist = function(_)
			require("trouble").open({ mode = "loclist" })
		end,

		-- `nvim-window-picker` integration
		-- window_pick = function(prompt_bufnr)
		-- 	local action_state = require("telescope.actions.state")
		-- 	local picker = action_state.get_current_picker(prompt_bufnr)
		-- 	picker.original_win_id = require("window-picker").pick_window()
		-- end,
	})

	telescope.setup({
		defaults = require("telescope.themes").get_ivy({
			prompt_prefix = " " .. icons.lupa .. " ",
			prompt_title = false,
			results_title = false,
			preview_title = false,
			dynamic_preview_title = false,
			selection_caret = "   ",
			entry_prefix = "   ",
			initial_mode = "insert",
			selection_strategy = "reset",
			theme = "ivy",
			file_ignore_patterns = {},
			path_display = { "filename_first" },
			winblend = 0,
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
					["<CR>"] = actions.select_default + actions.center,
					["<S-esc>"] = actions.close,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-s>"] = actions.toggle_selection,
					["<C-|>"] = actions.select_vertical,
					["<C-_>"] = actions.select_horizontal,
					["<C-a>"] = actions.toggle_all,
					["<tab>"] = actions.toggle_selection + actions.move_selection_next,
					["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_loclist + custom_actions.open_trouble_loclist,
				},
				n = {
					["q"] = actions.close,
					["<esc>"] = actions.close,
					["<CR>"] = actions.select_default + actions.center,
					["|"] = actions.select_vertical,
					["_"] = actions.select_horizontal,
					["s"] = actions.toggle_selection,
					["<tab>"] = actions.toggle_selection + actions.move_selection_next,
					["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
					["<C-a>"] = actions.toggle_all,
					["<C-q>"] = actions.smart_send_to_loclist + custom_actions.open_trouble_loclist,
				},
			},
		}),

		pickers = {
			find_files = {
				theme = "ivy",
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
			},
		},

		extensions = {
			file_browser = {
				hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			frecency = {
				default_workspace = "CWD",
				show_filter_column = false,
				sorter = require("telescope.sorters").fuzzy_with_index_bias(),
				db_safe_mode = false,
			},
			jsonfly = {
				prompt_title = "JSON keys",
			},
		},
	})

	-- Load extensions
	-- Load them here to prevent other plugins from loading telescope before it is needed
	telescope.load_extension("fzf")
	telescope.load_extension("noice")
	telescope.load_extension("frecency")
	telescope.load_extension("jsonfly")

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
