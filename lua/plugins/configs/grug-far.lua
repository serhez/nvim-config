local M = {
	"MagicDuck/grug-far.nvim",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register({
		{
			"<leader>r",
			function()
				require("grug-far").open()
			end,
			desc = "Replace",
		},
		{
			"<leader>R",
			function()
				require("grug-far").open({ prefills = { flags = vim.fn.expand("%") } })
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
