-- TODO: At the moment, this lua port of the plugin does not support markdown
-- local M = {
-- 	"GCBallesteros/jupytext.nvim",
-- 	event = "VimEnter",
-- }
--
-- function M.config()
-- 	require("jupytext").setup({
-- 		style = "hydrogen",
-- 	})
-- end
--
-- return M

local M = {
	"goerz/jupytext.vim",
	ft = { "ipynb" },
}

function M.config()
	vim.g.jupytext_fmt = "md" -- "md" for markdown
	vim.g.jupytext_filetype_map = { md = "pandoc" }
end

return M
