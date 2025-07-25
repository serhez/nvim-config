local M = {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"xzbdmw/colorful-menu.nvim",
		"Kaiser-Yang/blink-cmp-avante",
		-- "Kaiser-Yang/blink-cmp-dictionary",
		"archie-judd/blink-cmp-words",
		"Kaiser-Yang/blink-cmp-git",
		"bydlw98/blink-cmp-env",
		"jmbuhr/cmp-pandoc-references",
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
			["<CR>"] = { "accept", "fallback" },
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
			["<C-d>"] = { "show_documentation", "fallback" },
			["<C-D>"] = { "hide_documentation", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = false,
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
				-- we want to prioritize placing the menu above
				-- so that the Copilot completions are visible
				direction_priority = { "n", "s" },
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
		},

		sources = {
			per_filetype = {
				avante = { "avante", "thesaurus" },
				octo = { "git" },
				gitcommit = { "git" },
				bash = { "env" },
				zsh = { "env" },
				markdown = { "pandoc_references", "thesaurus" },
				quarto = { inherit_defaults = true, "pandoc_references", "thesaurus" },
				text = { "thesaurus" },
			},
			providers = {
				avante = {
					module = "blink-cmp-avante",
					name = "Avante",
					opts = {},
				},
				thesaurus = {
					name = "blink-cmp-words",
					module = "blink-cmp-words.thesaurus",
					score_offset = -2,
					min_keyword_length = 3,

					opts = {
						-- Default pointers define the lexical relations listed under each definition,
						-- see Pointer Symbols below.
						-- Default is as below ("antonyms", "similar to" and "also see").
						pointer_symbols = { "!", "&", "^" },
					},
				},
				git = {
					module = "blink-cmp-git",
					name = "Git",
					opts = {},
				},
				env = {
					module = "blink-cmp-env",
					name = "Env",
					score_offset = -3,
					opts = {},
				},
				pandoc_references = {
					module = "cmp-pandoc-references.blink",
					name = "pandoc_references",
				},
			},
		},

		cmdline = {
			completion = {
				ghost_text = {
					enabled = false,
				},
				menu = {
					auto_show = true,
				},
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},
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
