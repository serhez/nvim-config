local M = {
    "rmagatti/session-lens",
    dependencies = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
}

function M.config()
    require("session-lens").setup({
        prompt_title = "Sessions",
        previewer = false,
    })
end

return M