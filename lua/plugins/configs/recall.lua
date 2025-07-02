local M = {
	"fnune/recall.nvim",
	version = "*",
}

function M.init()
	vim.opt.exrc = true
	vim.opt.secure = true
	vim.opt.shadafile = ".vim/project.shada"

	require("mappings").register({
		{ "<leader>m", group = "Marks" },
		{
			"<leader>mm",
			function()
				vim.notify("Toggled mark", vim.log.levels.INFO, { title = "Marks" })
				require("recall").toggle()
			end,
			desc = "Toggle",
		},
		{
			"<leader>mc",
			function()
				vim.notify("Cleared all project marks", vim.log.levels.INFO, { title = "Marks" })
				require("recall").clear()
			end,
			desc = "Clear",
		},
		{ "]m", require("recall").goto_next, desc = "Next mark" },
		{ "[m", require("recall").goto_prev, desc = "Previous mark" },
		{ "<leader>ml", require("recall.snacks").pick, desc = "List" },
	})
end

function M.config()
	require("recall").setup({
		snacks = {
			mappings = {
				unmark_selected_entry = {
					normal = "d",
					insert = "<C-d>",
				},
			},
		},
	})
end

return M
