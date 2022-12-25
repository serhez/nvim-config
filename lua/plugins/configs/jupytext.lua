local M = {
    "goerz/jupytext.vim",
    fp = "ipynb",
}

function M.config()
    vim.g.jupytext_fmt = "py" -- "md" for markdown
end

return M
