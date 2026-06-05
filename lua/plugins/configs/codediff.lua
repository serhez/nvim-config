local M = {
	"esmuellert/codediff.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	cmd = {
		"CodeDiff",
	},
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register({
		{ "<leader>gx", group = "Conflicts" },
		{ "<leader>gxa", group = "All" },
		{ "<leader>gc", "<cmd>CodeDiff history HEAD~100 %<cr>", desc = "Commits (file)" },
		{ "<leader>gC", "<cmd>CodeDiff history HEAD~100<cr>", desc = "Commits (workspace)" },
		{ "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diffs tool" },
		{ "<leader>gD", ":CodeDiff ", desc = "Diffs tool (specify targets)" },
		{ "<leader>gf", "<cmd>CodeDiff --inline file HEAD<cr>", desc = "Inline file diffs" },
	})
end

function M.config()
	require("codediff").setup({
		diff = {
			layout = "inline",
		},
		keymaps = {
			conflict = {
				accept_incoming = false,
				accept_current = false,
				accept_both = false,
				accept_all_incoming = "<leader>gxat", -- Accept ALL incoming changes
				accept_all_current = "<leader>gxao", -- Accept ALL current changes
				accept_all_both = "<leader>gxab", -- Accept ALL both changes
				discard_all = "<leader>gxax", -- Discard ALL, reset to base
				discard = false,
				next_conflict = false,
				prev_conflict = false,
				diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
				diffget_current = "3do", -- Get hunk from current (right/ours) buffer
			},
		},
	})

	require("git_conflicts").setup_codediff_explorer()
	require("window_backgrounds").setup_dark_bg_filetypes("UserCodeDiffDarkBackground", { "codediff-explorer" })
end

return M
