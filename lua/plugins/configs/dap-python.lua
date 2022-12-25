local M = {
	"mfussenegger/nvim-dap-python",
}

function M.config()
	local dap_python = require("dap-python")

	dap_python.setup("~/.virtualenvs/debugpy/bin/python")
	dap_python.test_runner = "pytest"
end

return M
