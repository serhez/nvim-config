local M = {
	"mfussenegger/nvim-dap-python",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.config()
	local dap = require("dap")
	local dap_python = require("dap-python")
	dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

	dap.adapters.python_remote = {
		type = "server",
		host = "127.0.0.1",
		port = 5678,
	}

	-- table.insert(dap.configurations.python, function()
	-- 	local remote_root = vim.fn.input("Remote codebase path: ")
	--
	-- 	-- Cancel if user hits Esc or Enter on empty
	-- 	if remote_root == "" then
	-- 		return nil
	-- 	end
	--
	-- 	return {
	-- 		type = "python_remote",
	-- 		request = "attach",
	-- 		name = "Attach Remote (Ask for Path)",
	-- 		pathMappings = {
	-- 			{
	-- 				localRoot = vim.fn.getcwd(),
	-- 				remoteRoot = remote_root,
	-- 			},
	-- 		},
	-- 	}
	-- end)
end

return M
