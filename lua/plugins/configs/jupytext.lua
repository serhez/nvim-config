local M = {
	"goerz/jupytext.vim",
	event = "VimEnter",
}

function M.config()
	vim.g.jupytext_fmt = "md" -- "md" for markdown
	vim.g.jupytext_filetype_map = { md = "pandoc" }

	-- Run initially
	-- vim.cmd("jupytext")
end

return M
