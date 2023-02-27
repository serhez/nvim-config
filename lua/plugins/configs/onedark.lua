local M = {
    "navarasu/onedark.nvim",
}

function M.config()
    require("onedark").setup({
        style = "dark",
    })
end

return M