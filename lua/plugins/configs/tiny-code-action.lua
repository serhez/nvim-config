local M = {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
	},
	event = "LspAttach",
}

function M.init()
	require("mappings").register({
		{
			"<leader>ca",
			function()
				require("tiny-code-action").code_action()
			end,
			desc = "Code action",
		},
	})
end

function M.config()
	require("tiny-code-action").setup({
		backend = "difftastic",
		picker = "snacks",
	})
end

return M
