local icons = require("icons")
local mappings = require("mappings")

local M = {
	"nvim-neo-tree/neo-tree.nvim",
	version = "v2.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
}

function M.init()
	mappings.register_normal({
		e = { "<cmd>Neotree toggle<cr>", "Explorer" },
	})
end

function M.config()
	vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

	require("neo-tree").setup({
		use_default_mappings = false,
		close_if_last_window = true,
		use_popups_for_input = false,
		popup_border_style = "single",
		enable_git_status = true,
		enable_diagnostics = true,
		source_selector = {
			winbar = true,
			content_layout = "center",
			tab_labels = {
				filesystem = " File",
				buffers = "➜ Buffs",
				git_status = " Git",
				diagnostics = "",
			},
		},
		default_component_configs = {
			indent = {
				padding = 1,
			},
			modified = {
				symbol = icons.git.modified,
			},
			git_status = {
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					deleted = icons.git.deleted,
					renamed = icons.git.renamed,
					untracked = icons.git.untracked,
					ignored = icons.git.ignored,
					unstaged = icons.git.unstaged,
					staged = icons.git.staged,
					conflict = icons.git.conflict,
				},
			},
		},
		window = {
			width = 30,
			auto_expand_width = true,
			mappings = {
				-- ["l"] = {
				-- 	"toggle_node",
				-- 	nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
				-- },
				["<2-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["l"] = "open",
				["<esc>"] = "revert_preview",
				["P"] = { "toggle_preview", config = { use_float = true } },
				["f"] = "focus_preview",
				-- ["S"] = "open_split",
				-- ["s"] = "open_vsplit",
				["S"] = "split_with_window_picker",
				["s"] = "vsplit_with_window_picker",
				["t"] = "open_tabnew",
				-- ["<cr>"] = "open_drop",
				-- ["t"] = "open_tab_drop",
				["w"] = "open_with_window_picker",
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
				["<"] = "prev_source",
				[">"] = "next_source",
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
			},
			never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
				".DS_Store",
				"thumbs.db",
				".git/",
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
		example = {
			window = {
				mappings = {
					["<cr>"] = "toggle_node",
					["<C-e>"] = "example_command",
					["d"] = "show_debug_info",
				},
			},
		},
	})
end

return M
