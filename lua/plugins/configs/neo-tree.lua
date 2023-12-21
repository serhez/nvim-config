local M = {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"s1n7ax/nvim-window-picker",
		-- "miversen33/netman.nvim",
	},
	cmd = "Neotree",
	branch = "main",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

M.window_width = 40

function M.init()
	require("mappings").register_normal({
		e = { "<cmd>Neotree action=focus source=filesystem position=left toggle=true reveal=true<cr>", "Explorer" },
		o = {
			"<cmd>Neotree action=focus source=document_symbols position=right toggle=true reveal=true<cr>",
			"Outline",
		},
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
		open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
		hide_root_node = true,

		sources = {
			"filesystem",
			-- "netman.ui.neo-tree",
			"git_status",
			-- "buffers",
			"document_symbols",
		},

		source_selector = {
			winbar = true,
			content_layout = "center",
			separator = {
				left = "",
				right = "",
			},
			sources = {
				{
					source = "filesystem",
					display_name = icons.folder.default .. " Files",
				},
				{
					source = "remote",
					display_name = icons.globe .. " Remote",
				},
				{
					source = "git_status",
					display_name = icons.git.github .. " Git",
				},
				{
					source = "buffers",
					display_name = icons.file.files .. " Buffers",
				},
				{
					source = "document_symbols",
					display_name = icons.abc .. " Symbols",
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
					modified = "",
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
			width = M.window_width,
			auto_expand_width = false,
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
				["r"] = "rename",
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<S-tab>"] = "prev_source",
				["<tab>"] = "next_source",
				["<S-cr>"] = function(state)
					local node = state.tree:get_node()
					if require("neo-tree.utils").is_expandable(node) then
						state.commands["toggle_node"](state)
					else
						state.commands["open"](state)
						vim.cmd("Neotree reveal")
					end
				end,
			},
		},

		filesystem = {
			follow_current_file = {
				enabled = true,
			},
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
					["a"] = "add",
					["A"] = "add_directory",
					["c"] = "copy",
					["d"] = "delete",
					["H"] = "toggle_hidden",
					["m"] = "move",
					["p"] = "paste_from_clipboard",
					["x"] = "cut_to_clipboard",
					["y"] = "copy_to_clipboard",
					["/"] = "fuzzy_finder",
					["?"] = "fuzzy_finder_directory",
					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
					["o"] = "system_open",
					["D"] = "diff_files",
				},
			},
			commands = {
				system_open = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					-- macOs: open file in default application in the background.
					-- Probably you need to adapt the Linux recipe for manage path with spaces. I don't have a mac to try.
					vim.api.nvim_command("silent !open -g " .. path)
					-- Linux: open file in default application
					vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
				end,
				diff_files = function(state)
					local node = state.tree:get_node()
					local log = require("neo-tree.log")
					state.clipboard = state.clipboard or {}
					if diff_Node and diff_Node ~= tostring(node.id) then
						local current_Diff = node.id
						require("neo-tree.utils").open_file(state, diff_Node, open)
						vim.cmd("vert diffs " .. current_Diff)
						log.info("Diffing " .. diff_Name .. " against " .. node.name)
						diff_Node = nil
						current_Diff = nil
						state.clipboard = {}
						require("neo-tree.ui.renderer").redraw(state)
					else
						local existing = state.clipboard[node.id]
						if existing and existing.action == "diff" then
							state.clipboard[node.id] = nil
							diff_Node = nil
							require("neo-tree.ui.renderer").redraw(state)
						else
							state.clipboard[node.id] = { action = "diff", node = node }
							diff_Name = state.clipboard[node.id].node.name
							diff_Node = tostring(state.clipboard[node.id].node.id)
							log.info("Diff source file " .. diff_Name)
							require("neo-tree.ui.renderer").redraw(state)
						end
					end
				end,
			},
		},

		buffers = {
			bind_to_cwd = true,
			follow_current_file = {
				enabled = true,
			},
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

		document_symbols = {
			follow_cursor = false,
			window = {
				mappings = {
					["l"] = "toggle_node",
				},
			},
		},

		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.signcolumn = "auto"
				end,
			},
			-- {
			-- 	event = "file_opened",
			-- 	handler = function(file_path)
			-- 		--auto close
			-- 		vim.cmd("Neotree close")
			-- 	end,
			-- },
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		NeoTreeNormal = { fg = c.statusline_fg, bg = c.statusline_bg },
		NeoTreeTabActive = { fg = c.fg, bg = c.statusline_bg },
		NeoTreeTabInactive = { fg = c.statusline_fg, bg = c.cursor_line_bg },
		NeoTreeTabSeparatorActive = { fg = c.statusline_bg, bg = c.cursor_line_bg },
		NeoTreeTabSeparatorInactive = { fg = c.statusline_bg, bg = c.bg },
		NeoTreeFileNameOpened = { fg = c.cursor_line_fg, bg = c.cursor_line_bg },
	})
end

return M
