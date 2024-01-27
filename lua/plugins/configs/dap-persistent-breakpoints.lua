local M = {
	"Weissle/persistent-breakpoints.nvim",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		d = {
			b = { "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", "Toggle breakpoint" },
			B = {
				d = { "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", "Delete all" },
				c = {
					"<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>",
					"Set conditional breakpoint",
				},
			},
		},
	})
end

function M.config()
	require("persistent-breakpoints").setup({
		load_breakpoints_event = { "BufReadPost" },
	})
end

return M
