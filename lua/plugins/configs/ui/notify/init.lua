local notify = require("notify")
vim.notify = notify

notify.setup({
	level = "warn",
	stages = "fade",
	icons = {
		ERROR = " ",
		WARN = " ",
		INFO = " ",
		DEBUG = " ",
		TRACE = " ",
	},
	on_open = function(win)
		vim.api.nvim_win_set_config(win, { border = "single" })
	end,
})
