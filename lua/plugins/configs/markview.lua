local M = {
	"serhez/markview.nvim",
	dependencies = {
		-- You may not need this if you don't lazy load
		-- Or if the parsers are in your $RUNTIMEPATH
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "quarto", "rmd", "ipynb" },
	enabled = false,
}

function M.config()
	require("markview").setup({
		modes = { "n", "no", "i", "v", "V", "^V", "r", "x", "c" },

		-- Returns the conceallevel to the global value when changing modes
		restore_conceallevel = true,
		-- Returns the concealcursor to the global value when changing modes
		restore_concealcursor = false,

		code_blocks = {
			enable = true,

			style = "language",
			hl = "Layer2",

			min_width = 60,

			-- FIX: The left padding breaks insert mode (if still concealing) and `hlchunk` indent guides
			--      It would also be great to have left vs. right padding differentiation
			pad_amount = 0,

			language_names = {
				{ "py", "python" },
				{ "cpp", "C++" },
			},
			language_direction = "right",

			sign = true,
			sign_hl = nil,
		},
	})
end

return M
