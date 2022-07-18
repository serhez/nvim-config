require("neotest").setup({
    adapters = {
        require("neotest-python")({
            runner = "pytest",
        }),
        require("neotest-go")({
            experimental = {
                test_table = true,
            },
            args = { "-count=1", "-timeout=60s" },
        }),
        require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.ts",
        }),
    },
})
