local M = {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
}

function M.config()
    require("Comment").setup()
end

return M
