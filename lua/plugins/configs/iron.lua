local M = {
	"Vigemus/iron.nvim",
}

function M.config()
	require("iron.core").setup({
		config = {
			repl_open_cmd = require("iron.view").split.vertical.rightbelow("30%"),
			scratch_repl = true,
			close_window_on_exit = true,
			ignore_blank_lines = true,

			repl_definition = {
				sh = {
					command = { "zsh" },
				},
				python = {
					-- command = { "python3" },
					-- command = { "euporie", "console" },
					-- command = { "nbterm" },
					-- command = { "jupyter", "console", "--existing" },
					command = {
						"ipython",
						"--no-autoindent",
						"--pprint",
						"--no-banner",
						"--no-tip",
						"--no-term-title",
					},
					format = require("iron.fts.common").bracketed_paste_python,
					block_dividers = { "# %%", "#%%" },
				},
			},
		},
	})
end

return M
