local mappings = require("mappings")

local M = {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	mappings.register_normal({
		g = {
			b = {
				c = { "<cmd>DiffviewFileHistory %<cr>", "List commits" },
				d = { "<cmd>DiffviewOpen -- %<cr>", "Diffs" },
				D = { "<cmd>DiffviewOpen -- % ", "Diffs (specify commits)" },
			},
			d = { "<cmd>DiffviewOpen<cr>", "Diffs tool" },
			D = { "<cmd>DiffviewOpen ", "Diffs tool (specify commits)" },
			l = {
				c = { "<cmd>DiffviewFileHistory %<cr>", "Commits (file)" },
				C = { "<cmd>DiffviewFileHistory<cr>", "Commits (workspace)" },
			},
		},
	})
end

function M.config()
	require("diffview").setup({
		enhanced_diff_hl = true,
	})
end

return M
