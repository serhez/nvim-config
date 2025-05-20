local M = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional
	},
	cmd = "Neogit",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register({ "<leader>gp", "<cmd>Neogit<cr>", desc = "Panel" })
end

function M.config()
	local icons = require("icons")

	require("neogit").setup({
		disable_hint = true,
		disable_insert_on_commit = false,
		kind = "auto",
		signs = {
			-- { CLOSED, OPENED }
			hunk = { "", "" },
			item = { icons.arrow.right_short_thick, icons.arrow.down_short_thick },
			section = { icons.arrow.right_short_thick, icons.arrow.down_short_thick },
		},
		commit_editor = {
			kind = "split",
		},
		integrations = {
			diffview = true,
			snacks = true,
		},
	})
end

return M
