local M = {
	"ggandor/leap.nvim",
	event = "VeryLazy",
	dependencies = {
		"ggandor/flit.nvim",
		"ggandor/leap-spooky.nvim",
	},
}

function M.config()
	local leap = require("leap")

	-- Normal mapping: bidirectional and all windows
	vim.keymap.set("n", "m", function()
		leap.leap({
			target_windows = vim.tbl_filter(function(win)
				return vim.api.nvim_win_get_config(win).focusable
			end, vim.api.nvim_tabpage_list_wins(0)),
		})
	end, { silent = true, remap = true })

	-- Visual mapping: bidirectional and current window
	vim.keymap.set("v", "m", function()
		local current_window = vim.fn.win_getid()
		leap.leap({ target_windows = { current_window } })
	end, { silent = true, remap = true })
end

return M
