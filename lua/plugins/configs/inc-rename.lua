local M = {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
}

function M.config()
    require("inc_rename").setup()
end

return M
