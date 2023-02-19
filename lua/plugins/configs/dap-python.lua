local M = {
	"mfussenegger/nvim-dap-python",
}

function M.config()
	local dap_python = require("dap-python")
	dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
	-- dap_python.test_runner = "pytest"
end

return M
