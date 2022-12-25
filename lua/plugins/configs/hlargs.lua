local M = {
    "m-demare/hlargs.nvim",
    event = "BufReadPost",
}

function M.config()
    require("hlargs").setup()

    -- Function parameters highlighting (used by hlargs)
    vim.cmd("autocmd ColorScheme * highlight! link Hlargs TSParameter")
    vim.cmd("highlight! link Hlargs TSParameter")
end

return M
