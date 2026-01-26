local M = {
	"madmaxieee/unclash.nvim",
	lazy = false, -- unclash is lazy-loaded by default
}

function M.init()
	local unclash = require("unclash")
	require("mappings").register({
		{ "<leader>C", group = "Conflicts" },
		{ "<leader>Cc", unclash.accept_current, desc = "Accept current" },
		{ "<leader>Ci", unclash.accept_incoming, desc = "Accept incoming" },
		{ "<leader>Cb", unclash.accept_both, desc = "Accept both" },
		{ "<leader>Cq", "<cmd>UnclashTrouble<cr>", desc = "Quickfix" },
	})
end

function M.config()
	require("unclash").setup({})
end

return M
