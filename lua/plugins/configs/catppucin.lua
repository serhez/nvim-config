local M = {
    "catppuccin/nvim",
    name = "catppuccin",
}

function M.config()
    require("catppuccin").setup({
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        transparent_background = true,
        compile = {
            enabled = true,
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = "italic",
                    hints = "italic",
                    warnings = "italic",
                    information = "italic",
                },
                underlines = {
                    errors = "undercurl",
                    hints = "undercurl",
                    warnings = "undercurl",
                    information = "undercurl",
                },
            },
            coc_nvim = false,
            lsp_trouble = true,
            cmp = true,
            lsp_saga = false,
            gitgutter = false,
            gitsigns = true,
            telescope = true,
            nvimtree = {
                enabled = true,
                show_root = false,
                transparent_panel = true,
            },
            neotree = {
                enabled = false,
                show_root = false,
                transparent_panel = false,
            },
            which_key = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false,
            },
            dashboard = false,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = true,
            markdown = true,
            lightspeed = false,
            leap = true,
            ts_rainbow = false,
            hop = false,
            notify = true,
            telekasten = false,
            symbols_outline = false,
            mini = false,
        },
    })
end

return M