local M = {
	"kosayoda/nvim-lightbulb",
	event = "VeryLazy",
}

function M.config()
	local icons = require("icons")

	require("nvim-lightbulb").setup({
		-- Priority of the lightbulb for all handlers except float.
		priority = 10,

		-- Whether or not to hide the lightbulb when the buffer is not focused.
		-- Only works if configured during NvimLightbulb.setup
		hide_in_unfocused_buffer = true,

		-- Whether or not to link the highlight groups automatically.
		-- Default highlight group links:
		--   LightBulbSign -> DiagnosticSignInfo
		--   LightBulbFloatWin -> DiagnosticFloatingInfo
		--   LightBulbVirtualText -> DiagnosticVirtualTextInfo
		--   LightBulbNumber -> DiagnosticSignInfo
		--   LightBulbLine -> CursorLine
		-- Only works if configured during NvimLightbulb.setup
		link_highlights = true,

		-- Code action kinds to observe.
		-- To match all code actions, set to `nil`.
		-- Otherwise, set to a table of kinds.
		-- Example: { "quickfix", "refactor.rewrite" }
		-- See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeActionKind
		action_kinds = nil,

		-- Configuration for various handlers:
		-- 1. Sign column.
		sign = {
			enabled = false,
			-- Text to show in the sign column.
			-- Must be between 1-2 characters.
			text = "💡",
			-- Highlight group to highlight the sign column text.
			hl = "DiagnosticInfo",
		},

		-- 2. Virtual text.
		virtual_text = {
			enabled = false,
			-- Text to show in the virt_text.
			text = "💡",
			-- Position of virtual text given to |nvim_buf_set_extmark|.
			-- Can be a number representing a fixed column (see `virt_text_pos`).
			-- Can be a string representing a position (see `virt_text_win_col`).
			pos = "eol",
			-- Highlight group to highlight the virtual text.
			hl = "LightBulbVirtualText",
			-- How to combine other highlights with text highlight.
			-- See `hl_mode` of |nvim_buf_set_extmark|.
			hl_mode = "combine",
		},

		-- 3. Floating window.
		float = {
			enabled = false,
			-- Text to show in the floating window.
			text = "💡",
			-- Highlight group to highlight the floating window.
			hl = "LightBulbFloatWin",
			-- Window options.
			-- See |vim.lsp.util.open_floating_preview| and |nvim_open_win|.
			-- Note that some options may be overridden by |open_floating_preview|.
			win_opts = {
				focusable = false,
			},
		},

		-- 4. Status text.
		-- When enabled, will allow using |NvimLightbulb.get_status_text|
		-- to retrieve the configured text.
		status_text = {
			enabled = true,
			-- Text to set if a lightbulb is available.
			text = icons.lightbulb,
			-- Text to set if a lightbulb is unavailable.
			text_unavailable = "",
		},

		-- 5. Number column.
		number = {
			enabled = false,
			-- Highlight group to highlight the number column if there is a lightbulb.
			hl = "LightBulbNumber",
		},

		-- 6. Content line.
		line = {
			enabled = false,
			-- Highlight group to highlight the line if there is a lightbulb.
			hl = "LightBulbLine",
		},

		-- Autocmd configuration.
		-- If enabled, automatically defines an autocmd to show the lightbulb.
		-- If disabled, you will have to manually call |NvimLightbulb.update_lightbulb|.
		-- Only works if configured during NvimLightbulb.setup
		autocmd = {
			-- Whether or not to enable autocmd creation.
			enabled = true,
			-- See |updatetime|.
			-- Set to a negative value to avoid setting the updatetime.
			updatetime = 100,
			-- See |nvim_create_autocmd|.
			events = { "CursorHold", "CursorHoldI" },
			-- See |nvim_create_autocmd| and |autocmd-pattern|.
			pattern = { "*" },
		},

		-- Scenarios to not show a lightbulb.
		ignore = {
			-- LSP client names to ignore.
			-- Example: {"null-ls", "lua_ls"}
			clients = {},
			-- Filetypes to ignore.
			-- Example: {"neo-tree", "lua"}
			ft = {},
			-- Ignore code actions without a `kind` like refactor.rewrite, quickfix.
			actions_without_kind = false,
		},
	})
end

return M
