local icons = require("icons")
local colors = require("colors")

require("coverage").setup({
    commands = true, -- create commands
    highlights = {
        covered = { fg = colors.groups.CoverageCovered.fg, bg = colors.groups.CoverageCovered.bg },
        uncovered = { fg = colors.groups.CoverageUncovered.fg, bg = colors.groups.CoverageUncovered.bg },
    },
    signs = {
        covered = { hl = "CoverageCovered", text = icons.none },
        uncovered = { hl = "CoverageUncovered", text = icons.none },
    },
    summary = {
        min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
    },
})
