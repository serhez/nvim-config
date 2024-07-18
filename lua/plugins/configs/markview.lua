local M = {
	"serhez/markview.nvim",
	ft = { "markdown", "quarto", "rmd", "ipynb" },
	dependencies = {
		-- You may not need this if you don't lazy load
		-- Or if the parsers are in your $RUNTIMEPATH
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}

function M.config()
	require("markview").setup({
		modes = { "n", "no", "i", "v", "V", "^V", "r", "x", "c" },

		-- Returns the conceallevel to the global value when changing modes
		restore_conceallevel = false,
		-- Returns the concealcursor to the global value when changing modes
		restore_concealcursor = false,
	})
end

return M
