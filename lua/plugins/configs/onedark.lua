local M = {
    "navarasu/onedark.nvim",
}

function M.config()
    require("onedark").setup({
        style = "light",
    })
end

return M