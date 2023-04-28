local M = {
	"Weissle/persistent-breakpoints.nvim",
	event = "BufReadPost",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		d = {
			b = { "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", "Toggle breakpoint" },
			B = {
				c = { "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", "Clear" },
				C = {
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
