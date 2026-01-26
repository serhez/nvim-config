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
		{ "<leader>C", group = "Conflicts" },
		{ "<leader>gc", "<cmd>CodeDiff history HEAD~100 %<cr>", desc = "Commits (file)" },
		{ "<leader>gC", "<cmd>CodeDiff history HEAD~100<cr>", desc = "Commits (workspace)" },
		{ "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diffs tool" },
		{ "<leader>gD", ":CodeDiff ", desc = "Diffs tool (specify targets)" },
	})
end

function M.config()
	require("codediff").setup({
		keymaps = {
			conflict = {
				accept_incoming = "<leader>CI", -- Accept incoming (theirs/left) change
				accept_current = "<leader>CC", -- Accept current (ours/right) change
				accept_both = "<leader>CB", -- Accept both changes (incoming first)
				discard = "<leader>Cx", -- Discard both, keep base
				next_conflict = "]x", -- Jump to next conflict
				prev_conflict = "[x", -- Jump to previous conflict
				diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
				diffget_current = "3do", -- Get hunk from current (right/ours) buffer
			},
		},
	})
end

return M
