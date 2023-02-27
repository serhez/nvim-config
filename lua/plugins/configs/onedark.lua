local M = {
    "navarasu/onedark.nvim",
}

function M.config()
    require("onedark").setup({
        style = "darker",
    })
end

return M