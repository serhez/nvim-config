local M = {
	"GCBallesteros/jupytext.nvim",
	event = "VimEnter",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	require("jupytext").setup({
		style = "hydrogen",
		custom_language_formatting = {
			python = {
				extension = "qmd",
				style = "quarto",
				force_ft = "quarto",
			},
			julia = {
				extension = "qmd",
				style = "quarto",
				force_ft = "quarto",
			},
		},
	})
end

return M
