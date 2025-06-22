local M = {
	"Weissle/persistent-breakpoints.nvim",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
	event = "VeryLazy",
}

function M.init()
	require("mappings").register({
		{
			"<leader>db",
			"<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>",
			desc = "Toggle breakpoint",
		},

		{ "<leader>dB", group = "Breakpoints" },
		{
			"<leader>dBd",
			"<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>",
			desc = "Delete all",
		},
		{
			"<leader>dBc",
			"<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>",
			desc = "Set conditional breakpoint",
		},
	})
end

function M.config()
	require("persistent-breakpoints").setup({
		load_breakpoints_event = { "BufReadPost" },
	})
end

return M
