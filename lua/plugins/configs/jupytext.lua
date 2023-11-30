local M = {
	"GCBallesteros/jupytext.nvim",
	event = "VimEnter",
}

function M.config()
	require("jupytext").setup({
		style = "hydrogen",
	})
end

return M
