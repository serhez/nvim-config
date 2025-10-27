-- NOTE: complements with `nvim-custom-diagnostic-highlight`, which is able to detect
--       unused variables besides function parameters

local M = {
	"m-demare/hlargs.nvim",
	event = "VeryLazy",
}

function M.config()
	require("hlargs").setup({
		-- LSP Semantic tokens: 95
		-- Treesitter: 100
		-- HLArgs: 105
		hl_priority = 105,
		extras = {
			unused_args = { link = "Comment" },
		},
	})
end

return M
