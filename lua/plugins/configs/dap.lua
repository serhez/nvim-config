-- NOTE: DAP is currently loaded by the dap-persistent-breakpoints plugin, which may be inneficient

local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		-- "theHamsta/nvim-dap-virtual-text",
		"LiadOz/nvim-dap-repl-highlights",
	},
	cmd = {
		"DapToggleBreakpoint",
		"DapClearBreakpoints",
		"DapListBreakpoints",
		"DapContinue",
		"DapTest",
	},
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		d = {
			B = {
				l = { "<cmd>execute 'lua require(\"dap\").list_breakpoints()' | cope<cr>", "List" },
			},
			c = { "<cmd>DapContinue<cr>", "Continue / Start" },
			g = {
				name = "Go to",
				c = { "<cmd>DapGoToCursor<cr>", "Go to cursor" },
				l = { ":DapGoToLine ", "Go to line" },
			},
			i = {
				name = "Item",
				c = { "<cmd>DapClass<cr>", "Class" },
				s = { "<cmd>DapVisualSelection<cr>", "Selection" },
				t = { "<cmd>DapTest<cr>", "Test" },
			},
			p = { ":DapPauseThread ", "Pause thread" },
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
			t = { "<cmd>DapTerminate<cr>", "Terminate" },
		},
	})
end

function M.config()
	local dap = require("dap")

	local icons = require("icons")
	local hls = require("highlights")
	local c = hls.colors()

	hls.register_hls({
		DapBreakpointText = { fg = c.red },
		DapBreakpointLine = {},
		DapBreakpointNum = {},
	})
	vim.fn.sign_define("DapBreakpoint", {
		text = icons.dap.breakpoint,
		texthl = "DapBreakpointText",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpointNum",
	})
	vim.fn.sign_define("DapBreakpointCondition", {
		text = icons.dap.breakpoint_conditional,
		texthl = "DapBreakpointText",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpointNum",
	})
	vim.fn.sign_define("DapLogPoint", {
		text = icons.dap.breakpoint_log,
		texthl = "DapBreakpointText",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpointNum",
	})
	vim.fn.sign_define("DapStopped", {
		text = icons.dap.stopped,
		texthl = "DapBreakpointText",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpointNum",
	})
	vim.fn.sign_define("DapBreakpointRejected", {
		text = icons.dap.breakpoint_rejected,
		texthl = "DapBreakpointText",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpointNum",
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

	-- Load launch.json files
	local vscode = require("dap.ext.vscode")
	vscode.load_launchjs("launch.json")
	vscode.load_launchjs(".vscode/launch.json")
end

return M
