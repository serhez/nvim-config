local icons = require("icons")

require("nvim-tree").setup({
    update_cwd = true,
    hijack_cursor = true,
    update_focused_file = {
        enable = true,
    },

    renderer = {
        icons = {
            glyphs = {
                default = icons.page,
                symlink = icons.file.symlink,
                git = {
                    unstaged = icons.git.unstaged,
                    staged = icons.git.staged,
                    unmerged = icons.git.unmerged,
                    renamed = icons.git.renamed,
                    untracked = icons.git.untracked,
                },
                folder = {
                    default = icons.folder.default,
                    open = icons.folder.open,
                    empty = icons.folder.empty,
                    empty_open = icons.folder.empty_open,
                    symlink = icons.folder.symlink,
                },
            },
        },
    },

    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = icons.diagnostics.hint,
            info = icons.diagnostics.info,
            warning = icons.diagnostics.warning,
            error = icons.diagnostics.error,
        },
    },

    filters = {
        dotfiles = true,
        custom = {},
    },

    view = {
        mappings = {
            list = {
                { key = { "<CR>", "l" }, action = "edit", mode = "n" },
                { key = { "<BS>", "h" }, action = "close_node", mode = "n" },
            },
        },
    },

    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})

-- Auto close on exit
vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")
