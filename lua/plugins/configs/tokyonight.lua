local M = {
    "folke/tokyonight.nvim",
}

function M.config()
    local tokyonight = require("tokyonight")
    tokyonight.setup()
    tokyonight.load()
end

return M
