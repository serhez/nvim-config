local M = {
    "Shatur/neovim-ayu",
}

function M.config()
    require("ayu").setup({
        mirage = true,
        overrides = {},
    })
end

return M