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

-- Attach DAP UI to DAP events
dap.listeners.after.event_initialized["dapui_config"] = function()
    dap_ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dap_ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dap_ui.close()
end
