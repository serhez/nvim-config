local M = {
	"chrisgrieser/nvim-recorder",
	event = "BufRead",
}

function M.config()
	require("recorder").setup({
		mapping = {
			startStopRecording = "m",
			playMacro = "M",
			switchSlot = "<C-m>",
			editMacro = "cm",
			yankMacro = "ym", -- also decodes it for turning macros to mappings
			deleteAllMacros = "dm",
			addBreakPoint = "##", -- this should be a string you don't use in insert mode during a macro
		},

		-- Share keymaps with nvim-dap
		dapSharedKeymaps = false,

		-- clears all macros-slots on startup
		clear = false,

		-- log level used for any notification, mostly relevant for nvim-notify
		-- (note that by default, nvim-notify does not show the levels trace and debug.)
		logLevel = vim.log.levels.INFO,

		-- if enabled, only essential or critical notifications are sent.
		-- If you do not use a plugin like nvim-notify, set this to `true`
		-- to remove otherwise annoying notifications.
		lessNotifications = false,
	})
end

return M
