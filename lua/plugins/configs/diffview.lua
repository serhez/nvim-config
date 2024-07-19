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
	require("mappings").register({
		{ "<leader>gc", "<cmd>DiffviewFileHistory %<cr>", desc = "Commits (file)" },
		{ "<leader>gC", "<cmd>DiffviewFileHistory<cr>", desc = "Commits (workspace)" },
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffs tool" },
		{ "<leader>gD", "<cmd>DiffviewOpen ", desc = "Diffs tool (specify commits)" },

		{ "<leader>gf", group = "File" },
		{ "<leader>gfc", "<cmd>DiffviewFileHistory %<cr>", desc = "List commits" },
		{ "<leader>gfd", "<cmd>DiffviewOpen -- %<cr>", desc = "Diffs" },
		{ "<leader>gfD", "<cmd>DiffviewOpen -- % ", desc = "Diffs (specify commits)" },
	})
end

function M.config()
	require("diffview").setup({
		enhanced_diff_hl = true,
	})
end

return M
