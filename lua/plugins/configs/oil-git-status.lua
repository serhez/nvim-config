local M = {
	"serhez/oil-git-status.nvim",
	dev = true,
	name = "oil-git-status",
	dependencies = {
		"stevearc/oil.nvim",
	},
	cmd = "Oil",
	cond = not vim.g.started_by_firenvim,
}

function M.config()
	local icons = require("icons")

	require("oil-git-status").setup({
		show_ignored = true, -- show files that match gitignore with !!
		symbols = { -- customize the symbols that appear in the git status columns
			index = {
				["!"] = icons.git.ignored,
				["?"] = icons.git.untracked,
				["A"] = icons.git.added,
				["C"] = icons.git.copied,
				["D"] = icons.git.deleted,
				["M"] = icons.git.modified,
				["R"] = icons.git.renamed,
				["T"] = icons.git.type_changed,
				["U"] = icons.git.unmerged,
				[" "] = " ",
			},
			working_tree = {
				["!"] = icons.git.ignored,
				["?"] = icons.git.untracked,
				["A"] = icons.git.added,
				["C"] = icons.git.copied,
				["D"] = icons.git.deleted,
				["M"] = icons.git.modified,
				["R"] = icons.git.renamed,
				["T"] = icons.git.type_changed,
				["U"] = icons.git.unmerged,
				[" "] = " ",
			},
		},
		highlighs = {},
	})
end

return M
