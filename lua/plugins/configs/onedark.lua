local M = {
    "navarasu/onedark.nvim",
}

function M.config()
    require("onedark").setup({
        style = "cool",
    })
end

return M