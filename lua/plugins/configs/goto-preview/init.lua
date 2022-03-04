require('goto-preview').setup {
    default_mappings = true, -- gpd, gpi, gP
    post_open_hook = function(buffer, _)
        vim.api.nvim_buf_set_keymap(buffer, 'n', 'q', ':q<CR>', { noremap = true })
    end
}