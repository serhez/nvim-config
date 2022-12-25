local M = {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    fp = "ipynb",
}

function M.config()
    vim.g.magma_automatically_open_output = false
    vim.g.magma_image_provider = "ueberzug"
end

return M
