local icons = require("icons")

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
