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
}

function M.init()
	mappings.register_normal({
		g = {
			b = {
				t = { "<cmd>DiffviewFileHistory %<cr>", "List commits" },
				d = { "<cmd>DiffviewOpen -- %<cr>", "Diffs" },
				D = { ":DiffviewOpen -- % ", "Diffs (specify commits)" },
			},
			d = { "<cmd>DiffviewOpen<cr>", "Diffs tool" },
			D = { ":DiffviewOpen ", "Diffs tool (specify commits)" },
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
