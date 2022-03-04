require 'lspsaga'.setup {
    use_saga_diagnostic_sign = false,
    code_action_prompt = {
        enable = true,
        sign = false,
        sign_priority = 40,
        virtual_text = false,
    },
    rename_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
    },
    border_style = "single",
    rename_output_qflist = {
        enable = false,
        auto_open_qflist = false,
    },
}

vim.api.nvim_set_keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gu", "<cmd>Lspsaga lsp_finder<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>cu", "<cmd>Lspsaga lsp_finder<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>cD", "<cmd>Lspsaga show_cursor_diagnostics<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", {noremap = true, silent = true})

