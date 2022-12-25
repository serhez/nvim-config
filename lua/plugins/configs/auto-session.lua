local M = {
    "rmagatti/auto-session",
    event = "VimEnter",
}

function M.config()
    require("auto-session").setup({
        log_level = "error",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
    })
end

return M
