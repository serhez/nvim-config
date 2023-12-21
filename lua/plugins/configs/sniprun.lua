local mappings = require("mappings")

local M = {
	"michaelb/sniprun",
	build = "bash install.sh",
	cmd = "SnipRun",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	mappings.register_normal({
		r = { "<cmd>SnipRun<cr>", "Run code" },
		R = { "<cmd>SnipLive<cr>", "Run code live" },
	})
	mappings.register_visual({
		r = { "<cmd>SnipRun<cr>", "Run" },
	})
end

function M.config()
	require("sniprun").setup({
		--# You can combo different display modes as desired
		display = {
			-- "Classic", --# display results in the command-line  area
			-- "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)
			-- "VirtualText",          --# display error results as virtual text
			-- "TempFloatingWindow",      --# display results in a floating window
			-- "LongTempFloatingWindow", --# same as above, but only long results. To use with VirtualText__
			"Terminal", --# display results in a vertical split
			-- "TerminalWithCode",        --# display results and code history in a vertical split
			-- "NvimNotify",              --# display with the nvim-notify plugin
			-- "Api"                      --# return output to a programming interface
		},

		live_display = {
			"Terminal",
		},

		display_options = {
			terminal_width = 45, --# change the terminal display option width
			notification_timeout = 5, --# timeout for nvim_notify output
		},

		--# You can use the same keys to customize whether a sniprun producing
		--# No output should display nothing or '(no output)'
		show_no_output = {
			"Classic",
		},

		live_mode_toggle = "enable", --# live mode toggle, see Usage - Running for more info
		borders = "none",
	})
end

return M
