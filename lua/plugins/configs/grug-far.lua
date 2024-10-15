local M = {
	"MagicDuck/grug-far.nvim",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register({
		{
			"<leader>r",
			function()
				require("grug-far").grug_far()
			end,
			desc = "Replace",
		},
		{
			"<leader>R",
			function()
				require("grug-far").grug_far({ prefills = { flags = vim.fn.expand("%") } })
			end,
			desc = "Replace (buffer)",
		},
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
