local M = {
	"andymass/vim-matchup",
	lazy = false,
}

function M.init()
	-- Avoid synchronous delimiter searches on every CursorMoved while keeping
	-- match highlighting once navigation settles.
	vim.g.matchup_matchparen_deferred = 1
end

function M.config()
	require("match-up").setup({
		treesitter = {
			stopline = 500,
		},
	})
end

return M
