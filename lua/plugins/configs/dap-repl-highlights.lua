local M = {
	"LiadOz/nvim-dap-repl-highlights",
}

function M.config()
	require("nvim-dap-repl-highlights").setup()
end

return M
