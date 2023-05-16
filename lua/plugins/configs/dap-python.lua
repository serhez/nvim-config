local M = {
	"mfussenegger/nvim-dap-python",
}

function M.config()
	local dap_python = require("dap-python")
	dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
	-- dap_python.test_runner = "pytest"
	-- table.insert(require("dap").configurations.python, {
	-- 	type = "python",
	-- 	request = "launch",
	-- 	name = "Launch file (external breakpoints)",
	-- 	program = "${file}",
	-- 	justMyCode = false,
	-- 	-- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
	-- })
end

return M
