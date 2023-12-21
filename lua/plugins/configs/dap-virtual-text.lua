local M = {
	"theHamsta/nvim-dap-virtual-text",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	require("nvim-dap-virtual-text").setup()
end

return M
