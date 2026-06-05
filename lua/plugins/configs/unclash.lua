local M = {
	"madmaxieee/unclash.nvim",
	lazy = false, -- unclash is lazy-loaded by default
}

function M.init()
	local conflicts = require("git_conflicts")
	require("mappings").register({
		{ "<leader>gx", group = "Conflicts" },
		{ "<leader>gxb", conflicts.accept_both, desc = "Accept both" },
		{ "<leader>gxc", conflicts.accept_current, desc = "Accept current" },
		{ "<leader>gxi", conflicts.accept_incoming, desc = "Accept incoming" },
		{ "<leader>gxm", conflicts.open_merge_editor, desc = "Merge editor" },
		{ "<leader>gxq", "<cmd>UnclashTrouble<cr>", desc = "Quickfix" },
		{ "<leader>gxx", conflicts.discard, desc = "Discard to base" },
		{ "]x", conflicts.next_conflict, desc = "Next conflict" },
		{ "[x", conflicts.prev_conflict, desc = "Previous conflict" },
	})
end

function M.config()
	require("unclash").setup({})
end

return M
