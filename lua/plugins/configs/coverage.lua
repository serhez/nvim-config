local icons = require("icons")
local mappings = require("mappings")
local hls = require("highlights")

local M = {
	"andythigpen/nvim-coverage",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = {
		"Coverage",
		"CoverageLoad",
		"CoverageShow",
		"CoverageHide",
		"CoverageToggle",
		"CoverageClear",
		"CoverageSummary",
	},
	enabled = false,
}

function M.init()
	mappings.register_normal({
		T = {
			c = {
				name = "Coverage",
				c = { "<cmd>CoverageClear<cr>", "Clear" },
				l = { "<cmd>Coverage<cr>", "Load" },
				s = { "<cmd>CoverageSummary<cr>", "Summary" },
				t = { "<cmd>CoverageToggle<cr>", "Toggle signs" },
			},
		},
	})
end

function M.config()
	require("coverage").setup({
		commands = true, -- create commands
		highlights = {
			covered = { link = "CoverageCovered" },
			uncovered = { link = "CoverageUncovered" },
		},
		signs = {
			covered = { hl = "CoverageCovered", text = icons.none },
			uncovered = { hl = "CoverageUncovered", text = icons.none },
		},
		summary = {
			min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
		},
		lang = {
			go = {
				coverage_file = ".test_coverage.txt",
			},
		},
	})

	local c = hls.colors()
	hls.register_hls({
		CoverageCovered = { fg = c.bg, bg = c.green },
		CoverageUncovered = { fg = c.bg, bg = c.red },
	})
end

return M
