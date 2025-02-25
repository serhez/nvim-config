local M = {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"xzbdmw/colorful-menu.nvim",
		"saghen/blink.compat",
	},
	-- use a release tag to download pre-built binaries
	version = "v0.*",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	build = "cargo build --release",
	event = "InsertEnter",
}

function M.config()
	require("blink-cmp").setup({
		-- for keymap, all values may be string | string[]
		-- use an empty table to disable a keymap
		keymap = {
			["<C-space>"] = { "show", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_next()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_prev()
					end
				end,
				"snippet_backward",
				"fallback",
			},

			["<C-k>"] = { "show_documentation", "fallback" },
			["<C-K>"] = { "hide_documentation", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = true,
			-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- adjusts spacing to ensure icons are aligned
			nerd_font_variant = "normal",
		},

		-- experimental signature help support
		signature = {
			enabled = true,
			window = {
				border = "single",
			},
		},

		completion = {
			ghost_text = { enabled = false },
			list = {
				-- Controls how the completion items are selected
				-- 'preselect' will automatically select the first item in the completion list
				-- 'manual' will not select any item by default
				-- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 50,
			},
			-- colorful-menu.nvim integration
			menu = {
				draw = {
					-- We don't need label_description now because label and label_description are already
					-- conbined together in label by colorful-menu.nvim.
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},

			-- `nvim-highlight-colors` integration; not needed for now, as blink already supports colour hints
			-- menu = {
			-- 	draw = {
			-- 		components = {
			-- 			-- customize the drawing of kind icons
			-- 			kind_icon = {
			-- 				text = function(ctx)
			-- 					-- default kind icon
			-- 					local icon = ctx.kind_icon
			-- 					-- if LSP source, check for color derived from documentation
			-- 					if ctx.item.source_name == "LSP" then
			-- 						local color_item = require("nvim-highlight-colors").format(
			-- 							ctx.item.documentation,
			-- 							{ kind = ctx.kind }
			-- 						)
			-- 						if color_item and color_item.abbr then
			-- 							icon = color_item.abbr
			-- 						end
			-- 					end
			-- 					return icon .. ctx.icon_gap
			-- 				end,
			-- 				highlight = function(ctx)
			-- 					-- default highlight group
			-- 					local highlight = "BlinkCmpKind" .. ctx.kind
			-- 					-- if LSP source, check for color derived from documentation
			-- 					if ctx.item.source_name == "LSP" then
			-- 						local color_item = require("nvim-highlight-colors").format(
			-- 							ctx.item.documentation,
			-- 							{ kind = ctx.kind }
			-- 						)
			-- 						if color_item and color_item.abbr_hl_group then
			-- 							highlight = color_item.abbr_hl_group
			-- 						end
			-- 					end
			-- 					return highlight
			-- 				end,
			-- 			},
			-- 		},
			-- 	},
			-- },
		},

		sources = {
			-- NOTE: unfortunate that we cannot extend this,
			--       so it may not be up-to-date with all newest built-in sources
			--       Use `:BlinkCmp status` to check if there are any disabled sources
			default = { "lsp", "path", "snippets", "buffer", "obsidian", "obsidian_new", "obsidian_tags" },

			providers = {
				obsidian = { name = "obsidian", module = "blink.compat.source" },
				obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
				obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
			},
		},
	})

	local hls = require("highlights")
	local common_hls = hls.common_hls()
	hls.register_hls({
		BlinkCmpSignatureHelp = { bg = common_hls.statusline_bg },
		BlinkCmpSignatureHelpBorder = common_hls.border_statusline,
	})
end

return M
