local M = {
	"LiadOz/nvim-dap-repl-highlights",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	require("nvim-dap-repl-highlights").setup()
end

return M
