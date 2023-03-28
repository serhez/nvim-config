local icons = require("icons")
local mappings = require("mappings")

local M = {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"theHamsta/nvim-dap-virtual-text",
	},
}

local debug_win = nil
local debug_tab = nil

local function open_in_tab()
	if debug_win and vim.api.nvim_win_is_valid(debug_win) then
		vim.api.nvim_set_current_win(debug_win)
		return
	end

	vim.cmd("tabedit %")
	debug_win = vim.fn.win_getid()
	debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
	require("dapui").open()
end

local function close_tab()
	require("dapui").close()

	if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
		vim.api.nvim_exec("tabclose " .. debug_tab, false)
	end

	debug_win = nil
	debug_tab = nil
end

function M.init()
	mappings.register_normal({
		d = {
			name = "Debug",
			e = { "<cmd>lua require('dapui').eval()<cr>", "Evaluate" },
		},
	})
end

function M.config()
	local dap, dap_ui = require("dap"), require("dapui")

	dap_ui.setup({
		expand_lines = vim.fn.has("nvim-0.7"),
		force_buffers = true,
		icons = {
			expanded = icons.arrow.down_short,
			collapsed = icons.arrow.right_short,
			current_frame = icons.arrow.double_right_short,
		},
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>", "l" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		layouts = {
			{
				elements = {
					{
						id = "scopes",
						size = 0.55,
					},
					{
						id = "watches",
						size = 0.15,
					},
					{
						id = "stacks",
						size = 0.15,
					},
					{
						id = "breakpoints",
						size = 0.15,
					},
				},
				position = "left",
				size = 0.33,
			},
			{
				elements = {
					{
						id = "console",
						size = 1.0,
					},
				},
				position = "right",
				size = 0.33,
			},
		},
		floating = {
			max_height = 0.8, -- These can be integers or a float between 0 and 1.
			max_width = 0.8, -- Floats will be treated as percentage of your screen.
			border = "none",
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		controls = {
			enabled = true,
			element = "console",
			icons = {
				disconnect = icons.dap.disconnect,
				pause = icons.dap.pause,
				play = icons.dap.play,
				run_last = icons.dap.run_last,
				step_back = icons.dap.step_back,
				step_into = icons.dap.step_into,
				step_out = icons.dap.step_out,
				step_over = icons.dap.step_over,
				terminate = icons.dap.terminate,
			},
		},
		render = {
			indent = 1,
		},
	})

	-- Attach DAP UI to DAP events
	dap.listeners.after.event_initialized["dapui_config"] = function()
		open_in_tab()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		close_tab()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		close_tab()
	end
end

return M
