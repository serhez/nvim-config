local M = {
    "petertriho/cmp-git",
}

function M.config()
    require("cmp_git").setup()
end

return M
