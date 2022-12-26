local mappings = require("mappings")

local M = {
	"michaelb/sniprun",
	build = "bash install.sh",
	cmd = "SnipRun",
}

function M.init()
	mappings.register_normal({
		u = {
			r = { "<cmd>SnipRun<cr>", "Run code" },
			R = { "<cmd>SnipLive<cr>", "Run code live" },
		},
	})
	mappings.register_visual({
		R = { "<cmd>SnipRun<cr>", "Run" },
	})
end

function M.config()
	require("sniprun").setup({
		--# you can combo different display modes as desired
		display = {
			"Classic", --# display results in the command-line  area
			"VirtualTextOk", --# display ok results as virtual text (multiline is shortened)
			-- "VirtualTextErr",          --# display error results as virtual text
			-- "TempFloatingWindow",      --# display results in a floating window
			"LongTempFloatingWindow", --# same as above, but only long results. To use with VirtualText__
			-- "Terminal",                --# display results in a vertical split
			-- "TerminalWithCode",        --# display results and code history in a vertical split
			-- "NvimNotify",              --# display with the nvim-notify plugin
			-- "Api"                      --# return output to a programming interface
		},

		--# You can use the same keys to customize whether a sniprun producing
		--# no output should display nothing or '(no output)'
		show_no_output = {
			"Classic",
			"TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
		},

		live_mode_toggle = "off", --# live mode toggle, see Usage - Running for more info
	})
end

return M
