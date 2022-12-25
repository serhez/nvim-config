local icons = require("icons")

local M = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neotest/neotest-go",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-python",
    },
    cmd = {
        "TestDebugFile",
        "TestDebugNearest",
        "TestDebugSuite",
        "TestRunFile",
        "TestRunNearest",
        "TestRunSuite",
        "TestPanel",
        "TestStopNearest",
    },
}

function M.config()
    require("neotest").setup({
        floating = {
            border = "single",
        },
        adapters = {
            require("neotest-python")({
                runner = "pytest",
            }),
            require("neotest-go")({
                -- experimental = {
                -- test_table = true,
                -- },
                args = { "-count=1", "-timeout=60s" },
            }),
            require("neotest-jest")({
                jestCommand = "npm test --",
                jestConfigFile = "jest.config.ts",
            }),
        },
        icons = {
            running = icons.three_dots,
            expanded = icons.bar.upper_right_corner,
            final_child_prefix = icons.bar.lower_left_corner,
        },
    })
end

return M
