local M = {
	"saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",
	-- use a release tag to download pre-built binaries
	version = "v0.*",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
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
				selection = "auto_insert",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 50,
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
