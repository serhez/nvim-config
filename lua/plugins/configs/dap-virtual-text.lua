local M = {
	"theHamsta/nvim-dap-virtual-text",
	enabled = false,
}

function M.config()
	require("nvim-dap-virtual-text").setup()
end

return M
