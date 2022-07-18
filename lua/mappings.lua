-- Leader
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = " "

-- Better window movement
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { silent = true })

-- Terminal window navigation
vim.cmd([[
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
  inoremap <C-h> <C-\><C-N><C-w>h
  inoremap <C-j> <C-\><C-N><C-w>j
  inoremap <C-k> <C-\><C-N><C-w>k
  inoremap <C-l> <C-\><C-N><C-w>l
  tnoremap <Esc> <C-\><C-n>
]])

-- Resize with arrows
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- Better indenting
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- Tab switch buffer
vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> ("\\<C-n>")')
vim.cmd('inoremap <expr> <c-k> ("\\<C-p>")')
-- vim.cmd('inoremap <expr> <TAB> (\"\\<C-n>\")')
-- vim.cmd('inoremap <expr> <S-TAB> (\"\\<C-p>\")')

-- Incrementing and decrementing
vim.cmd("set nrformats=")
vim.api.nvim_set_keymap("n", "+", "<C-a>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "-", "<C-x>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "+", "g<C-a>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "-", "g<C-x>", { noremap = true, silent = true })

-- Respect wrapping with jk navigation
vim.cmd("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
vim.cmd("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

-- Switch to previous buffer with backspace
vim.api.nvim_set_keymap("n", "<Backspace>", "<C-^>", { noremap = true, silent = true })

-- Always center the cursor
vim.api.nvim_set_keymap("n", "{", "{zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "}", "}zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]c", "]czz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[c", "[czz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]j", "]jzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[j", "[jzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]s", "]szz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[s", "[szz", { noremap = true, silent = true })

-- Make . work over visual selections
vim.api.nvim_set_keymap("x", ".", ":norm.<CR>", { noremap = true, silent = true })

-- Avoid c storing in registers
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "C", '"_C', { noremap = true, silent = true })

-- Sensible clipboard paste in insert mode
vim.api.nvim_set_keymap("i", "<C-v>", "<C-r>*", { noremap = true, silent = true })

-- Y behaves like D and C
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true })

-- FIX: Remap to_lower() and let gu be used for go_to_usages()
-- vim.api.nvim_set_keymap("n", "gl", "gu", {noremap = false, silent = true})
-- vim.api.nvim_set_keymap("n", "gu", "<Nop>", {noremap = true, silent = true})

-- Commands

-- Testing
vim.api.nvim_create_user_command("TestRunNearest", "lua require('neotest').run.run()", { nargs = 0 })
vim.api.nvim_create_user_command("TestRunFile", "lua require('neotest').run.run(vim.fn.expand('%'))", { nargs = 0 })
vim.api.nvim_create_user_command("TestRunSuite", "lua require('neotest').run.run({suite = true})", { nargs = 0 })
vim.api.nvim_create_user_command(
    "TestDebugNearest",
    "lua require('neotest').run.run({strategy = 'dap'})",
    { nargs = 0 }
)
vim.api.nvim_create_user_command(
    "TestDebugFile",
    "lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})",
    { nargs = 0 }
)
vim.api.nvim_create_user_command(
    "TestDebugSuite",
    "lua require('neotest').run.run({suite = true, strategy = 'dap'})",
    { nargs = 0 }
)
vim.api.nvim_create_user_command("TestStopNearest", "lua require('neotest').run.stop()", { nargs = 0 })
vim.api.nvim_create_user_command("TestPanel", "lua require('neotest').summary.toggle()", { nargs = 0 })

-- DAP
vim.api.nvim_create_user_command("DapStart", "lua require'dap'.continue()", { nargs = 0 })
vim.api.nvim_create_user_command("DapContinue", "lua require'dap'.continue()", { nargs = 0 })
vim.api.nvim_create_user_command("DapStop", "lua require'dap'.terminate()", { nargs = 0 })
vim.api.nvim_create_user_command("DapToggleBreakpoint", "lua require'dap'.toggle_breakpoint()", { nargs = 0 })
vim.api.nvim_create_user_command("DapListBreakpoints", "lua require'dap'.list_breakpoints()", { nargs = 0 })
vim.api.nvim_create_user_command("DapClearBreakpoints", "lua require'dap'.clear_breakpoints()", { nargs = 0 })
vim.api.nvim_create_user_command("DapStepOver", "lua require'dap'.step_over()", { nargs = 0 })
vim.api.nvim_create_user_command("DapStepInto", "lua require'dap'.step_into()", { nargs = 0 })
vim.api.nvim_create_user_command("DapStepOut", "lua require'dap'.step_out()", { nargs = 0 })
vim.api.nvim_create_user_command("DapStepBack", "lua require'dap'.step_back()", { nargs = 0 })
vim.api.nvim_create_user_command("DapToggleREPL", "lua require'dap'.repl.toggle()", { nargs = 0 })
vim.api.nvim_create_user_command("DapPauseThread", "lua require'dap'.repl.pause(<q-args>)", { nargs = 1 })
vim.api.nvim_create_user_command("DapUp", "lua require'dap'.repl.up()", { nargs = 0 })
vim.api.nvim_create_user_command("DapDown", "lua require'dap'.repl.down()", { nargs = 0 })
vim.api.nvim_create_user_command("DapGoToLine", "lua require'dap'.repl.goto_(<q-args>)", { nargs = 1 })
vim.api.nvim_create_user_command("DapGoToCursor", "lua require'dap'.repl.run_to_cursor()", { nargs = 0 })
vim.api.nvim_create_user_command("DapTest", function()
    local filetype = vim.bo.filetype
    if filetype == "go" then
        vim.nvim_execute("lua require('dap-go').debug_test()")
    elseif filetype == "python" then
        vim.nvim_execute("lua require('dap-python').test_method()")
    else
        print("The current debugging adapter does not support debugging individual tests")
    end
end, { nargs = 0 })
vim.api.nvim_create_user_command("DapClass", function()
    local filetype = vim.bo.filetype
    if filetype == "python" then
        vim.nvim_execute("lua require('dap-python').test_class()")
    else
        print("The current debugging adapter does not support debugging individual classes")
    end
end, { nargs = 0 })
vim.api.nvim_create_user_command("DapVisualSelection", function()
    local filetype = vim.bo.filetype
    if filetype == "python" then
        vim.nvim_execute("lua require('dap-python').debug_selection()")
    else
        print("The current debugging adapter does not support debugging by visual selection")
    end
end, { nargs = 0 })

-- Comments
vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { noremap = false, silent = true })
vim.api.nvim_set_keymap("v", "<leader>/", "gcc", { noremap = false, silent = true })

local mappings = {
    ["/"] = "Comment",
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["q"] = { "<cmd>Bwipeout<cr>", "Close buffer" }, -- Shortcut
    ["Q"] = { "<cmd>tabclose<cr>", "Close tab" }, -- Shortcut
    ["s"] = {
        '<cmd>lua require("telescope.builtin").live_grep({ additional_args = function() return { "--ignore", "--hidden", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--glob=!.git/" } end })<cr>',
        "Search text",
    }, -- Shortcut
    ["S"] = {
        '<cmd>lua require("telescope.builtin").live_grep({ additional_args = function() return { "--no-ignore", "--hidden", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--glob=!.git/" } end })<cr>',
        "Search text (+ignored)",
    }, -- Shortcut
    ["U"] = { "<cmd>PackerSync<cr>", "Update" },

    b = {
        name = "Buffers",
        c = {
            name = "Close",
            a = { "<cmd>bufdo Bwipeout<cr>", "All" },
            c = { "<cmd>Bwipeout<cr>", "Current" },
            g = { "<cmd>BufferLineGroupClose<cr>", "Group" }, -- Redundancy
            l = { "<cmd>BufferLineCloseLeft<cr>", "Left of current" },
            o = { "<cmd>%Bdelete|e#<cr>", "Others" },
            p = { "<cmd>BufferLinePickClose<cr>", "Pick" },
            r = { "<cmd>BufferLineCloseRight<cr>", "Right of current" },
        },
        g = {
            name = "Group",
            c = { "<cmd>BufferLineGroupClose<cr>", "Close" }, -- Redundancy
            t = { "<cmd>BufferLineGroupToggle<cr>", "Toggle" },
        },
        l = { "<cmd>Telescope buffers<cr>", "List" }, -- Redundancy
        m = {
            name = "Move",
            h = { "<cmd>BufferLineMovePrev<cr>", "Previous" },
            l = { "<cmd>BufferLineMoveNext<cr>", "Next" },
        },
        p = { "<cmd>BufferLinePick<cr>", "Pick" },
        s = {
            name = "Sort",
            c = { "<cmd>BufferLineSortByDirectory<cr>", "By directory" },
            t = { "<cmd>BufferLineSortByExtension<cr>", "By extension" },
        },
    },

    c = {
        name = "Code",
        a = { "<cmd>CodeActionMenu<cr>", "Action" },
        d = { "Diagnostics (line)" },
        D = { "Diagnostics (cursor)" },
        f = { "<cmd>lua require'lsp'.format()<cr>", "Format" },
        F = { "<cmd>lua require'lsp'.toggle_auto_format()<cr>", "Toggle auto-format" },
        r = { "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols (file)" },
        S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Symbols (project)" },
        u = { "Usages" },
    },

    d = {
        name = "Debug",
        b = {
            name = "Breakpoints",
            c = { "<cmd>DapClearBreakpoints<cr>", "Clear" },
            l = { "<cmd>DapListBreakpoints<cr>", "List" },
            t = { "<cmd>DapToggleBreakpoint<cr>", "Toggle" },
        },
        c = { "<cmd>DapContinue<cr>", "Continue / Start" },
        g = {
            name = "Go to",
            c = { "<cmd>DapGoToCursor<cr>", "Go to cursor" },
            l = { ":DapGoToLine", "Go to line" },
        },
        i = {
            name = "Item",
            c = { "<cmd>DapClass<cr>", "Class" },
            s = { "<cmd>DapVisualSelection<cr>", "Selection" },
            t = { "<cmd>DapTest<cr>", "Test" },
        },
        p = { ":DapPauseThread", "Pause thread" },
        r = { "<cmd>DapToggleRepl<cr>", "REPL" },
        s = {
            name = "Step",
            b = { "<cmd>DapStepOver<cr>", "Back" },
            d = { "<cmd>DapDown<cr>", "Down" },
            i = { "<cmd>DapStepInto<cr>", "Into" },
            o = { "<cmd>DapStepOver<cr>", "Out" },
            O = { "<cmd>DapStepOver<cr>", "Over" },
            u = { "<cmd>DapUp<cr>", "Up" },
        },
        S = { "<cmd>DapStop<cr>", "Stop" },
    },

    f = {
        name = "Find",
        b = { "<cmd>Telescope buffers<cr>", "Buffers" }, -- Redundancy
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        f = {
            "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/<cr>",
            "Files",
        },
        F = {
            "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/<cr>",
            "Files (+ignored)",
        },
        m = { "<cmd>Telescope marks<cr>", "Marks" },
        M = { "<cmd>Telescope man_pages<cr>", "Man pages" },
        p = { "<cmd>Telescope session-lens search_session<cr>", "Projects" }, -- Redundancy
        r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
        t = {
            '<cmd>lua require("telescope.builtin").live_grep({ additional_args = function() return { "--ignore", "--hidden", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--glob=!.git/" } end })<cr>',
            "Text",
        },
        T = {
            '<cmd>lua require("telescope.builtin").live_grep({ additional_args = function() return { "--no-ignore", "--hidden", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--glob=!.git/" } end })<cr>',
            "Text (+ignored)",
        },
    },

    g = {
        name = "Git",
        a = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Author" },
        b = {
            name = "Buffer",
            t = { "<cmd>DiffviewFileHistory %<cr>", "List commits" },
            d = { "<cmd>DiffviewOpen -- %<cr>", "Diffs" },
            D = { ":DiffviewOpen -- % ", "Diffs (specify commits)" },
            r = { "<cmd>Gitsigns reset_buffer<cr>", "Revert" },
        },
        c = { "<cmd>GitConflictListQf<cr>", "Conflicts tool" },
        d = { "<cmd>DiffviewOpen<cr>", "Diffs tool" },
        D = { ":DiffviewOpen ", "Diffs tool (specify commits)" },
        h = {
            name = "Hunk",
            j = { "<cmd>Gitsigns next_hunk<cr>", "Next" },
            k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev" },
            p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview" },
            r = { "<cmd>Gitsigns reset_hunk<cr>", "Revert" },
        },
        l = {
            name = "List",
            b = { "<cmd>Telescope git_branches<cr>", "Branches" },
            c = { "<cmd>DiffviewFileHistory %<cr>", "Commits (file)" },
            C = { "<cmd>DiffviewFileHistory<cr>", "Commits (workspace)" },
            s = { "<cmd>Telescope git_stash<cr>", "Stashes" },
        },
        m = { "<cmd>GitMessenger<cr>", "Last commit message" },
    },

    p = {
        name = "Projects",
        l = { "<cmd>Telescope session-lens search_session<cr>", "List" }, -- Redundancy
    },

    t = {
        name = "Tests",
        d = {
            name = "Debug",
            f = { "<cmd>TestDebugFile<cr>", "File" },
            n = { "<cmd>TestDebugNearest<cr>", "Nearest" },
            s = { "<cmd>TestDebugSuite<cr>", "Suite" },
        },
        r = {
            name = "Run",
            f = { "<cmd>TestRunFile<cr>", "File" },
            n = { "<cmd>TestRunNearest<cr>", "Nearest" },
            s = { "<cmd>TestRunSuite<cr>", "Suite" },
        },
        p = { "<cmd>TestPanel<cr>", "Panel" },
        s = { "<cmd>TestStopNearest<cr>", "Stop nearest" },
    },

    T = {
        name = "Tabs",
        c = { "<cmd>tabclose<cr>", "Close (current)" },
        n = { "<cmd>tabnew<cr>", "New" },
    },

    u = {
        name = "Utils",
        c = { "<cmd>Codi!!<cr>", "Codi" },
        d = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Diagnostics (workspace)" },
        D = { "<cmd>DogeGenerate<cr>", "Generate docs" },
        h = { "<cmd>AddFileHeader<cr>", "Add header" },
        m = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown preview" },
        s = { "<cmd>lua require('spectre').open()<cr>", "Search & replace" },
        r = { "<cmd>SnipRun<cr>", "Run code" },
        R = { "<cmd>SnipLive<cr>", "Run code live" },
        t = { "<cmd>TodoTrouble<cr>", "Todos" },
        v = { "<cmd>Vista!!<cr>", "Vista" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

require("which-key").register(mappings, opts)
