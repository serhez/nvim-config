local M = {
	"leoluz/nvim-dap-go",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	require("dap-go").setup()
end

return M
