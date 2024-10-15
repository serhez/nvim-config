local M = {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
	},
}

function M.init()
	require("mappings").register({
		{
			"<leader>ca",
			function()
				require("tiny-code-action").code_action()
			end,
			desc = "Action",
		},
	})
end

function M.config()
	require("tiny-code-action").setup({
		telescope_opts = {
			sorting_strategy = "ascending",
			layout_strategy = "bottom_pane",
			layout_config = {
				width = 1.0,
				height = 25,
				preview_cutoff = 1,
			},
		},
	})
end

return M
