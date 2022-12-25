local icons = require("icons")

local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
	},
}

function M.config()
	local dap = require("dap")

	-- DAP breakpoint icon
	vim.fn.sign_define("DapBreakpoint", {
		text = icons.circle,
		texthl = "",
		linehl = "",
		numhl = "",
	})

	dap.adapters.python = {
		type = "executable",
		command = "/usr/bin/python",
		args = { "-m", "debugpy.adapter" },
	}

	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = function()
				return "/usr/bin/python"
			end,
		},
	}

	dap.adapters.cpp = {
		type = "executable",
		attach = {
			pidProperty = "pid",
			pidSelect = "ask",
		},
		command = "lldb-vscode",
		env = {
			LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
		},
		name = "lldb",
	}
end

return M
