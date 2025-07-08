local M = {
	"andymass/vim-matchup",
	lazy = false,
}

function M.config()
	require("match-up").setup({
		treesitter = {
			stopline = 500,
		},
	})
end

return M
