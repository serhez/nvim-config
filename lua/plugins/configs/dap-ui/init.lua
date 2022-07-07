local icons = require("icons")

require("dapui").setup({
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
    },
    layouts = {
        {
            elements = {
                -- You can change the order of elements in the sidebar
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 10,
            position = "bottom", -- Can be "bottom" or "top"
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
