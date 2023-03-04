local hls = require("highlights")

local M = {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
}

function M.config()
	local notify = require("notify")

	vim.notify = notify

	notify.setup({
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

	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		NotifyERRORBorder = common_hls.border,
		NotifyWARNBorder = common_hls.border,
		NotifyINFOBorder = common_hls.border,
		NotifyDEBUGBorder = common_hls.border,
		NotifyTRACEBorder = common_hls.border,
		NotifyERRORIcon = { fg = c.error_fg },
		NotifyWARNIcon = { fg = c.warn_fg },
		NotifyINFOIcon = { fg = c.info_fg },
		NotifyDEBUGIcon = { fg = c.magenta },
		NotifyTRACEIcon = { fg = c.hint_fg },
		NotifyERRORTitle = { fg = c.error_fg },
		NotifyWARNTitle = { fg = c.warn_fg },
		NotifyINFOTitle = { fg = c.info_fg },
		NotifyDEBUGTitle = { fg = c.magenta },
		NotifyTRACETitle = { fg = c.hint_fg },
		NotifyERRORBody = { bg = c.statusline_bg },
		NotifyWARNBody = { bg = c.statusline_bg },
		NotifyINFOBody = { bg = c.statusline_bg },
		NotifyDEBUGBody = { bg = c.statusline_bg },
		NotifyTRACEBody = { bg = c.statusline_bg },
	})
end

return M
