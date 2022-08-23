require("bqf").setup({
    auto_resize_height = true,
    preview = {
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        wrap = false,
        should_preview_cb = function(bufnr, _)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match("^fugitive://") then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end,
    },
})
