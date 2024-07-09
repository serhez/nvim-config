local M = {
	"glacambre/firenvim",

	-- Lazy load firenvim
	-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
	lazy = false,
	cond = not not vim.g.started_by_firenvim,
	build = function()
		require("lazy").load({ plugins = "firenvim", wait = true })
		vim.fn["firenvim#install"](0)
	end,
}

function M.config()
	vim.opt.showtabline = 0 -- don't show the tabline
	vim.opt.laststatus = 0 -- don't show the statusline
	if vim.opt.lines:get() == 1 then
		vim.opt.lines = 2 -- make sure there's room for firenvim
	end
	-- vim.lsp.diagnostic.disable() -- disable LSP diagnostics
end

return M
