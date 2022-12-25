local M = {
    "leoluz/nvim-dap-go",
}

function M.config()
    require("dap-go").setup()
end

return M
