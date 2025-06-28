local M = {
	"Vigemus/iron.nvim",
}

function M.config()
	require("iron.core").setup({
		config = {
			repl_open_cmd = require("iron.view").split.vertical.rightbelow("30%"),
			scratch_repl = true,
			close_window_on_exit = true,

			-- Your repl definitions come here
			repl_definition = {
				sh = {
					-- Can be a table or a function that
					-- returns a table (see below)
					command = { "zsh" },
				},
				python = {
					-- command = { "python3" },
					command = { "ipython", "--color-info" },
					format = require("iron.fts.common").bracketed_paste_python,
					block_dividers = { "# %%", "#%%" },
				},
			},
		},
		-- Ignore blank lines when sending visual select lines
		ignore_blank_lines = true,
	})
end

return M
