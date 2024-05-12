local M = {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	vim.api.nvim_create_user_command("GrugFar", "lua require('grug-far').grug_far()", {})
	require("mappings").register_normal({
		r = { "<cmd>GrugFar<cr>", "Replace" },
		R = { "<cmd>GrugFar<cr>", "Replace (buffer)" },
	})
end

function M.config()
	require("grug-far").setup({
		keymaps = {
			-- normal and insert mode
			replace = "<C-r>",
			qflist = "<C-q>",
			syncLocations = "<C-s>",
			close = "<C-x>",

			-- normal mode only
			gotoLocation = "<enter>",
		},
	})
end

return M
