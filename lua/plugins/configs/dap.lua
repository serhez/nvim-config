local icons = require("icons")
local mappings = require("mappings")

local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
	},
}

function M.init()
	mappings.register_normal({
		d = {
			name = "Debug",
			b = { "<cmd>DapToggleBreakpoint<cr>", "Toggle breakpoint" },
			B = {
				name = "Breakpoints",
				c = { "<cmd>DapClearBreakpoints<cr>", "Clear" },
				l = { "<cmd>DapListBreakpoints<cr>", "List" },
			},
			c = { "<cmd>DapContinue<cr>", "Continue / Start" },
			g = {
				name = "Go to",
				c = { "<cmd>DapGoToCursor<cr>", "Go to cursor" },
				l = { ":DapGoToLine", "Go to line" },
			},
			i = {
				name = "Item",
				c = { "<cmd>DapClass<cr>", "Class" },
				s = { "<cmd>DapVisualSelection<cr>", "Selection" },
				t = { "<cmd>DapTest<cr>", "Test" },
			},
			p = { ":DapPauseThread", "Pause thread" },
			r = { "<cmd>DapToggleRepl<cr>", "REPL" },
			s = {
				name = "Step",
				b = { "<cmd>DapStepOver<cr>", "Back" },
				d = { "<cmd>DapDown<cr>", "Down" },
				i = { "<cmd>DapStepInto<cr>", "Into" },
				O = { "<cmd>DapStepOver<cr>", "Out" },
				o = { "<cmd>DapStepOver<cr>", "Over" },
				u = { "<cmd>DapUp<cr>", "Up" },
			},
			S = { "<cmd>DapStop<cr>", "Stop" },
		},
	})
end

function M.config()
	local dap = require("dap")

	-- DAP breakpoint icon
	vim.fn.sign_define("DapBreakpoint", {
		text = icons.circle,
		texthl = "",
		linehl = "",
		numhl = "",
	})

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
