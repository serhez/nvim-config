local M = {
	"stevearc/resession.nvim",
	lazy = false,
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
	enabled = false,
}

function M.config()
	local resession = require("resession")

	resession.setup({
		-- Options for automatically saving sessions on a timer
		autosave = {
			enabled = false,
			-- How often to save (in seconds)
			interval = 60,
			-- Notify when autosaved
			notify = true,
		},
		-- Save and restore these options
		options = {
			"binary",
			"bufhidden",
			"buflisted",
			"cmdheight",
			"diff",
			"filetype",
			"modifiable",
			"previewwindow",
			"readonly",
			"scrollbind",
			"winfixheight",
			"winfixwidth",
		},
		-- Custom logic for determining if the buffer should be included
		buf_filter = require("resession").default_buf_filter,
		-- Show more detail about the sessions when selecting one to load.
		-- Disable if it causes lag.
		load_detail = true,
		-- List order ["modification_time", "creation_time", "filename"]
		load_order = "modification_time",
		-- Configuration for extensions
		extensions = {
			quickfix = {},
			hbac = {},
			oil = {},
		},
	})

	local function get_session_name()
		local name = vim.fn.getcwd()
		local branch = vim.trim(vim.fn.system("git branch --show-current"))
		if vim.v.shell_error == 0 then
			return name .. branch
		else
			return name
		end
	end
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			-- Only load the session if nvim was started with no args
			if vim.fn.argc(-1) == 0 then
				resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
			end
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			resession.save(get_session_name(), { dir = "dirsession", notify = true })
		end,
	})
end

return M
