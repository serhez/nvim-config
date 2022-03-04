vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {unstaged = "", staged = "✓", unmerged = "", renamed = "➜", untracked = ""},
    folder = {default = "", open = "", empty = "", empty_open = "", symlink = ""}
}

require'nvim-tree'.setup {
    auto_close = true,
    update_cwd = true,
    hijack_cursor = true,
    update_focused_file = {
        enable = true,
    },

    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    },

    filters = {
        dotfiles = true,
        custom = {},
    },

    view = {
        mappings = {
            list = {
                { key = {"<CR>", "l" }, action = "edit", mode = "n"},
                { key = {"<BS>", "h" }, action = "close_node", mode = "n"},
            }
        }
    },

    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
}

