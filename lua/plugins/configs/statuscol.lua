local M = {
	"luukvbaal/statuscol.nvim",
	event = "VimEnter",
}

function M.config()
	local builtin = require("statuscol.builtin")

	require("statuscol").setup({
		separator = " ", -- separator between line number and buffer text ("│" or extra " " padding)
		-- Builtin line number string options for ScLn() segment
		thousands = false, -- or line number thousands separator string ("." / ",")
		relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
		-- Builtin 'statuscolumn' options
		setopt = true, -- whether to set the 'statuscolumn', providing builtin click actions

		segments = {
			{
				sign = { name = { "Dap*" }, maxwidth = 1, colwidth = 1, auto = true },
				click = "v:lua.ScLa",
			},
			{
				sign = { name = { "todo*" }, maxwidth = 1 },
			},
			{
				sign = { name = { "Diagnostic" }, maxwidth = 1 },
				click = "v:lua.ScSa",
			},
			{
				text = { builtin.lnumfunc, " " },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScLa",
			},
			{
				sign = { name = { ".*" }, maxwidth = 1, colwidth = 1 },
				click = "v:lua.ScSa",
			},
			{
				text = { builtin.foldfunc, "" },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScFa",
			},
		},

		ft_ignore = {
			"neo-tree",
			"nvim-tree",
			"Outline",
			"Trouble",
			"lazy",
			"help",
			"spectre_panel",
			"toggleterm",
			"dapui_scopes",
			"dapui_breakpoints",
			"dapui_stacks",
			"dapui_watches",
			"dapui_console",
			"dapui_repl",
		},
		bt_ignore = { "nofile" },
	})
end

return M
