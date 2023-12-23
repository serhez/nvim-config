local M = {
	"GCBallesteros/jupytext.nvim",
	event = "VimEnter",
	branch = "support-more-than-just-auto",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	require("jupytext").setup({
		style = "hydrogen",
		custom_language_formatting = {
			python = {
				extension = "qmd",
				style = "quarto",
				force_ft = true,
			},
			julia = {
				extension = "qmd",
				style = "quarto",
				force_ft = true,
			},
		},
	})
end

return M
