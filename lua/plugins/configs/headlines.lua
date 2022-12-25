local M = {
    "lukas-reineke/headlines.nvim",
    ft = "markdown",
}

function M.config()
    require("headlines").setup()
end

return M
