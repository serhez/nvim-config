local icons = require("icons")
local mappings = require("mappings")

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

function M.init()
	mappings.register_normal({
		T = {
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
	})
end

function M.config()
	require("neotest").setup({
		floating = {
			border = "none",
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
			expanded = icons.bar.upper_right_corner_thin,
			final_child_prefix = icons.bar.lower_left_corner_thin,
		},
	})
end

return M
