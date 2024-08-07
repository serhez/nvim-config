local M = {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar", "GrugFarBuffer" },
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	vim.api.nvim_create_user_command("GrugFar", "lua require('grug-far').grug_far()", {})
	vim.api.nvim_create_user_command(
		"GrugFarBuffer",
		"lua require('grug-far').grug_far({ prefills = { flags = vim.fn.expand('%') } })",
		{}
	)

	require("mappings").register({
		{ "<leader>r", "<cmd>GrugFar<cr>", desc = "Replace" },
		{ "<leader>R", "<cmd>GrugFarBuffer<cr>", desc = "Replace (buffer)" },
	})
end

function M.config()
	require("grug-far").setup({
		keymaps = {
			replace = "",
			qflist = "<C-q>",
			syncLocations = "<C-a>",
			syncLine = "<C-l>",
			close = "q",
			gotoLocation = { n = "<enter>" },
		},
	})
end

return M
