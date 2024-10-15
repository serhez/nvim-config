-- NOTE: DAP is currently loaded by the dap-persistent-breakpoints plugin

local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		-- "theHamsta/nvim-dap-virtual-text",
		"LiadOz/nvim-dap-repl-highlights",
		"Weissle/persistent-breakpoints.nvim",
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
	require("mappings").register({
		{ "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue / Start" },
		{ "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
		{ "<leader>dp", ":DapPauseThread ", desc = "Pause thread" },
		{ "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "REPL" },

		{ "<leader>dB", group = "Breakpoints" },
		{ "<leader>dBl", "<cmd>execute 'lua require(\"dap\").list_breakpoints()' | cope<cr>", desc = "List" },

		{ "<leader>dg", group = "Go to" },
		{ "<leader>dgc", "<cmd>DapGoToCursor<cr>", desc = "Go to cursor" },
		{ "<leader>dgl", ":DapGoToLine ", desc = "Go to line" },

		{ "<leader>di", group = "Item" },
		{ "<leader>dic", "<cmd>DapClass<cr>", desc = "Class" },
		{ "<leader>dis", "<cmd>DapVisualSelection<cr>", desc = "Selection" },
		{ "<leader>dit", "<cmd>DapTest<cr>", desc = "Test" },

		{ "<leader>ds", group = "Step" },
		{ "<leader>dsb", "<cmd>DapStepOver<cr>", desc = "Back" },
		{ "<leader>dsd", "<cmd>DapDown<cr>", desc = "Down" },
		{ "<leader>dsi", "<cmd>DapStepInto<cr>", desc = "Into" },
		{ "<leader>dsO", "<cmd>DapStepOver<cr>", desc = "Out" },
		{ "<leader>dso", "<cmd>DapStepOver<cr>", desc = "Over" },
		{ "<leader>dsu", "<cmd>DapUp<cr>", desc = "Up" },
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
