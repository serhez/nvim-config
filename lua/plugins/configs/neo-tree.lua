local M = {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"s1n7ax/nvim-window-picker",
		"miversen33/netman.nvim",
	},
	cmd = "Neotree",
	branch = "main",
}

function M.init()
	require("mappings").register_normal({
		e = { "<cmd>Neotree toggle<cr>", "Explorer" },
	})
end

function M.config()
	local icons = require("icons")

	vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

	require("neo-tree").setup({
		use_default_mappings = false,
		close_if_last_window = true,
		use_popups_for_input = false,
		popup_border_style = "single",
		enable_git_status = true,
		enable_diagnostics = true,
		enable_opened_markers = true,

		sources = {
			"filesystem",
			-- "buffers",
			"netman.ui.neo-tree",
			"git_status",
		},

		source_selector = {
			winbar = true,
			content_layout = "center",
			separator = {
				left = icons.bar.vertical_left_thin,
				right = icons.bar.vertical_right_thin,
			},
			sources = {
				{
					source = "filesystem",
					display_name = icons.folder.default .. " File",
				},
				{
					source = "remote",
					display_name = icons.globe .. " Remote",
				},
				{
					source = "buffers",
					display_name = icons.file.files .. " Buffer",
				},
				{
					source = "git_status",
					display_name = icons.git.github .. " Git",
				},
			},
		},

		default_component_configs = {
			container = {
				enable_character_fade = false,
			},
			indent = {
				padding = 1,
				with_markers = true,
			},
			icon = {
				folder_closed = icons.folder.default,
				folder_open = icons.folder.open,
				folder_empty = icons.folder.empty,
				folder_empty_open = icons.folder.empty_open,
				-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
				-- then these will never be used.
				default = icons.file.page,
			},
			modified = {
				symbol = icons.git.modified,
			},
			name = {
				highlight_opened_files = "all",
			},
			git_status = {
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					deleted = icons.git.deleted,
					renamed = icons.git.renamed,
					untracked = icons.git.untracked,
					ignored = icons.git.ignored,
					unstaged = "",
					staged = "",
					conflict = icons.git.conflict,
				},
			},
		},

		window = {
			width = 30,
			auto_expand_width = true,
			mappings = {
				["<2-LeftMouse>"] = "open_with_window_picker",
				["<cr>"] = "open_with_window_picker",
				["l"] = "open_with_window_picker",
				["<esc>"] = "revert_preview",
				["K"] = { "toggle_preview", config = { use_float = true } },
				["f"] = "focus_preview",
				["S"] = "split_with_window_picker",
				["s"] = "vsplit_with_window_picker",
				["t"] = "open_tabnew",
				-- ["<cr>"] = "open_drop",
				-- ["t"] = "open_tab_drop",
				["C"] = "close_node",
				["z"] = "close_all_nodes",
				["Z"] = "expand_all_nodes",
				["a"] = "add",
				["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
				["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<S-tab>"] = "prev_source",
				["<tab>"] = "next_source",
			},
		},

		filesystem = {
			follow_current_file = true,
			hijack_netrw_behavior = "open_default",
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false,
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_by_name = {
					"node_modules",
					".git",
				},
				always_show = { -- remains visible even if other settings would normally hide it
					".gitignored",
				},
				never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
					".DS_Store",
					"thumbs.db",
				},
			},
			window = {
				mappings = {
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["H"] = "toggle_hidden",
					["/"] = "fuzzy_finder",
					["D"] = "fuzzy_finder_directory",
					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
				},
			},
		},

		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function(_)
					vim.opt_local.signcolumn = "auto"
				end,
			},
		},

		buffers = {
			bind_to_cwd = true,
			follow_current_file = true, -- This will find and focus the file in the active buffer every time
			-- the current file is changed while the tree is open.
			group_empty_dirs = true, -- when true, empty directories will be grouped together
			window = {
				mappings = {
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["bd"] = "buffer_delete",
				},
			},
		},

		git_status = {
			window = {
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
				},
			},
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		NeoTreeNormal = { fg = c.statusline_fg, bg = c.statusline_bg },
		NeoTreeTabActive = { fg = c.fg, bg = c.cursor_line_bg },
		NeoTreeTabInactive = { fg = c.statusline_fg, bg = c.bg },
		NeoTreeTabSeparatorActive = { fg = c.statusline_bg, bg = c.cursor_line_bg },
		NeoTreeTabSeparatorInactive = { fg = c.statusline_bg, bg = c.bg },
		NeoTreeFileNameOpened = { fg = c.cursor_line_fg, bg = c.cursor_line_bg },
	})
end

return M
