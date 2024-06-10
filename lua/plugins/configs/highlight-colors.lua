local M = {
	"brenoprata10/nvim-highlight-colors",
	event = "BufReadPre",
}

function M.config()
	require("nvim-highlight-colors").setup({
		---Render style
		---@usage 'background'|'foreground'|'virtual'
		render = "virtual",

		---Highlight tailwind colors, e.g. 'bg-blue-500'
		enable_tailwind = true,

		---Set virtual symbol suffix (defaults to '')
		virtual_symbol_prefix = " ",

		---Set virtual symbol suffix (defaults to ' ')
		virtual_symbol_suffix = "",

		---Set virtual symbol position()
		---@usage 'inline'|'eol'|'eow'
		---inline mimics VS Code style
		---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
		---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
		virtual_symbol_position = "eow",
	})
end

return M
