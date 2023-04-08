local M = {
	"goerz/jupytext.vim",
	event = "BufRead *.ipynb",
}

function M.config()
	vim.g.jupytext_fmt = "py" -- "md" for markdown
end

return M
