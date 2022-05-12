require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "→", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

-- dashboard
-- vim.api.nvim_set_keymap('n', '<leader>;', ':Dashboard<CR>', {noremap = true, silent = true})

-- Comments
vim.api.nvim_set_keymap("n", "<leader>/", "gcc", {noremap = false, silent = true})
vim.api.nvim_set_keymap("v", "<leader>/", "gcc", {noremap = false, silent = true})

local mappings = {
    ["/"] = "Comment",
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["q"] = { "<cmd>Bwipeout<cr>", "Close current buffer" },  -- Shortcut
    ["s"] = { "<cmd>Telescope live_grep<cr>", "Search text" },  -- Shortcut
    ["U"] = { "<cmd>PackerSync<cr>", "Update" },

    b = {
        name = "Buffers",
        c = {
            name = "Close",
            a = {"<cmd>bufdo Bwipeout<cr>", "All"},
            c = {"<cmd>Bwipeout<cr>", "Current"},
            g = {"<cmd>BufferLineGroupClose<cr>", "Group"},  -- Redundancy
            l = {"<cmd>BufferLineCloseLeft<cr>", "Left of current"},
            o = {"<cmd>%Bdelete|e#<cr>", "Others"},
            p = {"<cmd>BufferLinePickClose<cr>", "Pick"},
            r = {"<cmd>BufferLineCloseRight<cr>", "Right of current"},
        },
        g = {
            name = "Group",
            c = {"<cmd>BufferLineGroupClose<cr>", "Close"},  -- Redundancy
            t = {"<cmd>BufferLineGroupToggle<cr>", "Toggle"},
        },
        l = {"<cmd>Telescope buffers<cr>", "List"},  -- Redundancy
        m = {
            name = "Move",
            h = {"<cmd>BufferLineMovePrev<cr>", "Previous"},
            l = {"<cmd>BufferLineMoveNext<cr>", "Next"},
        },
        p = {"<cmd>BufferLinePick<cr>", "Pick"},
        s = {
            name = "Sort",
            c = {"<cmd>BufferLineSortByDirectory<cr>", "By directory"},
            t = {"<cmd>BufferLineSortByExtension<cr>", "By extension"},
        },
    },

    c = {
        name = "Code",
        a = {"<cmd>CodeActionMenu<cr>", "Action"},
        d = {"Diagnostics (line)"},
        D = {"Diagnostics (cursor)"},
        f = {"<cmd>lua require'lsp'.format()<cr>", "Format"},
        F = {"<cmd>lua require'lsp'.toggle_auto_format()<cr>", "Toggle auto-format"},
        r = {"Rename"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Symbols (file)"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Symbols (project)"},
        u = {"Usages"},
    },

    d = {
        name = "Debug",
        b = {"<cmd>DebugToggleBreakpoint<cr>", "Toggle breakpoint"},
        c = {"<cmd>DebugContinue<cr>", "Continue"},
        i = {"<cmd>DebugStepInto<cr>", "Step into"},
        o = {"<cmd>DebugStepOver<cr>", "Step over"},
        r = {"<cmd>DebugToggleRepl<cr>", "Toggle repl"},
        s = {"<cmd>DebugStart<cr>", "Start"},
    },

    f = {
        name = "Find",
        b = {"<cmd>Telescope buffers<cr>", "Buffers"},  -- Redundancy
        c = {"<cmd>Telescope commands<cr>", "Commands"},
        f = {"<cmd>Telescope find_files<cr>", "Files"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        M = {"<cmd>Telescope man_pages<cr>", "Man pages"},
        r = {"<cmd>Telescope oldfiles<cr>", "Recent files"},
        t = {"<cmd>Telescope live_grep<cr>", "Text"},
    },

    g = {
        name = "Git",
        a = {"<cmd>Gitsigns toggle_current_line_blame<cr>", "Author"},
        b = {"<cmd>Telescope git_branches<cr>", "Branches"},
        c = {"<cmd>Telescope git_bcommits<cr>", "Commits (file)"},
        C = {"<cmd>Telescope git_commits<cr>", "Commits (workspace)"},
        d = {"<cmd>DiffviewOpen<cr>", "Diffs"},
        h = {"<cmd>Gitsigns preview_hunk<cr>", "Hunk details"},
        j = {"<cmd>Gitsigns next_hunk<cr>", "Next hunk"},
        k = {"<cmd>Gitsigns prev_hunk<cr>", "Prev hunk"},
        l = {"<cmd>GitMessenger<cr>", "Last commit message"},
        L = {"<cmd>Gitsigns toggle_linehl<cr>", "Line highlighting"},
        r = {"<cmd>Gitsigns reset_hunk<cr>", "Reset hunk"},
        R = {"<cmd>Gitsigns reset_buffer<cr>", "Reset buffer"},
        s = {"<cmd>Telescope git_stash<cr>", "Stashes"},
        t = {"<cmd>DiffviewFileHistory<cr>", "Commit tree (file)"},
        T = {"<cmd>DiffviewFileHistory .<cr>", "Commit tree (workspace)"},
    },

    t = {
        name = "Tab",
        c = {"<cmd>tabclose<cr>", "Close (current)"},
        n = {"<cmd>tabnew<cr>", "New"},
    },

    u = {
        name = "Utils",
        c = {"<cmd>Codi!!<cr>", "Codi"},
        d = {"<cmd>TroubleToggle workspace_diagnostics<cr>", "Diagnostics (workspace)"},
        D = {"<cmd>DogeGenerate<cr>", "Generate docs"},
        h = {"<cmd>AddFileHeader<cr>", "Add header"},
        m = {"<cmd>MarkdownPreviewToggle<cr>", "Markdown preview"},
        s = {"<cmd>lua require('spectre').open()<cr>", "Search & replace"},
        r = {"<cmd>SnipRun<cr>", "Run code"},
        R = {"<cmd>SnipLive<cr>", "Run code live"},
        t = {"<cmd>TodoTrouble<cr>", "Todos"},
        v = {"<cmd>Vista!!<cr>", "Vista"},
    },
}

local wk = require("which-key")
wk.register(mappings, opts)
