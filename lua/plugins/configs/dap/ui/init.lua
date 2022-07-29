local icons = require("icons")
local dap, dap_ui = require("dap"), require("dapui")

dap_ui.setup({
    icons = {
        expanded = icons.arrow.down_short,
        collapsed = icons.arrow.right_short,
        circular = icons.arrow.circular,
    },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    expand_lines = vim.fn.has("nvim-0.7"),
    layouts = {
        {
            elements = {
                -- You can change the order of elements in the sidebar
                { id = "scopes", size = 0.35 },
                { id = "stacks", size = 0.35 },
                { id = "breakpoints", size = 0.15 },
                { id = "watches", size = 0.15 },
            },
            size = 0.33,
            position = "left", -- Can be "left" or "right"
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

local debug_win = nil
local debug_tab = nil

local function open_in_tab()
    if debug_win and vim.api.nvim_win_is_valid(debug_win) then
        vim.api.nvim_set_current_win(debug_win)
        return
    end

    vim.cmd("tabedit %")
    debug_win = vim.fn.win_getid()
    debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
    dap_ui.open()
end

local function close_tab()
    dap_ui.close()

    if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
        vim.api.nvim_exec("tabclose " .. debug_tab, false)
    end

    debug_win = nil
    debug_tab = nil
end

-- Attach DAP UI to DAP events
dap.listeners.after.event_initialized["dapui_config"] = function()
    open_in_tab()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    close_tab()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    close_tab()
end
