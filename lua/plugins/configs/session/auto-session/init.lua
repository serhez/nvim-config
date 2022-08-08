local function close_all_floating_wins()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end

require("auto-session").setup({
    log_level = "error",
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    pre_save_cmds = { close_all_floating_wins }, -- TODO: Remove when Neovim version >= 0.8
})