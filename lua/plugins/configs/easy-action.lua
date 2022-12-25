local M = {
    "Weissle/easy-action",
}

function M.config()
    require("easy-action").setup({
        jump_provider = "leap",
    })
end

return M