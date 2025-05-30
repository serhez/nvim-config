-- NOTE: complements with `hlargs.nvim`, which is able to detect unused function parameters
--       even when no diagnostics are triggered

local M = {
	"Kasama/nvim-custom-diagnostic-highlight",
	event = "VeryLazy",
}

function M.config()
	-- BUG: This plugin needs an empty table to be passed to setup
	require("nvim-custom-diagnostic-highlight").setup({
		highlight_group = "Comment",
	})
end

return M
