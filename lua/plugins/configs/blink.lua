local M = {
	"saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",

	-- use a release tag to download pre-built binaries
	version = "v0.*",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	event = "InsertEnter",
	enabled = false,
}

function M.config()
	require("blink-cmp").setup({
		-- for keymap, all values may be string | string[]
		-- use an empty table to disable a keymap
		keymap = {
			show = "<C-space>",
			hide = "<C-e>",
			accept = "<C-CR>",
			select_prev = "<S-Tab>",
			select_next = "<Tab>",

			show_documentation = "<C-k>",
			hide_documentation = "<C-K>",
			scroll_documentation_up = "<C-b>",
			scroll_documentation_down = "<C-f>",

			snippet_forward = "<Tab>",
			snippet_backward = "<S-Tab>",
		},

		highlight = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = true,
		},
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		nerd_font_variant = "normal",

		-- experimental auto-brackets support
		accept = { auto_brackets = { enabled = true } },

		-- experimental signature help support
		trigger = { signature_help = { enabled = true } },
	})
end

return M
