local icons = require("icons")

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
