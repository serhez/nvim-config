local M = {
	"luukvbaal/statuscol.nvim",
	event = "VimEnter",
}

function M.config()
	require("statuscol").setup({
		separator = " ", -- separator between line number and buffer text ("│" or extra " " padding)
		-- Builtin line number string options for ScLn() segment
		thousands = false, -- or line number thousands separator string ("." / ",")
		relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
		-- Builtin 'statuscolumn' options
		setopt = true, -- whether to set the 'statuscolumn', providing builtin click actions
		order = "FSNs", -- order of the fold, sign, line number and separator segments
		ft_ignore = {
			"neo-tree",
			"nvim-tree",
			"spectre_panel",
			"toggleterm",
			"dapui_scopes",
			"dapui_breakpoints",
			"dapui_stacks",
			"dapui_watches",
			"dapui_console",
			"dapui_repl",
		},
	})
end

return M
