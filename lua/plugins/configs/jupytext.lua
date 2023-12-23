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
			},
		},
	})
end

return M

-- local M = {
-- 	"goerz/jupytext.vim",
-- 	ft = { "ipynb" },
-- }
--
-- function M.config()
-- 	vim.g.jupytext_fmt = "md" -- "md" for markdown
-- 	vim.g.jupytext_filetype_map = { md = "pandoc" }
-- end
--
-- return M
