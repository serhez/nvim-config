local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
	enabled = false,
}

function M.config()
	vim.g.indent_blankline_filetype_exclude = { "dashboard", "WhichKey", "help" }
	vim.g.indent_blankline_char = "│"
	vim.g.indent_blankline_space_char = " "
	vim.g.indent_blankline_char_highlight_list = { "Comment" }
	vim.g.indent_blankline_viewport_buffer = 50 -- how many lines up and down it looks out of screen view to determine context (can hurt performance)
	vim.g.indent_blankline_context_patterns = {
		"class",
		"function",
		"method",
		"^if",
		"^while",
		"^for",
		"^object",
		"^table",
		"^try",
		"^do",
		"block",
		"arguments",
	}
	vim.cmd("let g:indent_blankline_show_trailing_blankline_indent = v:false")
	vim.cmd("let g:indent_blankline_show_first_indent_level = v:true")
	vim.cmd("let g:indent_blankline_use_treesitter = v:true")
	vim.cmd("let g:indent_blankline_show_current_context = v:true")
	vim.cmd([[
    augroup IndentBlanklineContextAutogroup
        autocmd!
        autocmd CursorMoved * IndentBlanklineRefresh
    augroup END
    ]])
end

return M
