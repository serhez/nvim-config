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
	leap.add_default_mappings()

	-- Remove unused keymappings
	vim.keymap.del({ "n", "o", "v" }, "S")
	vim.keymap.del({ "x", "o" }, "x")
	vim.keymap.del({ "x", "o" }, "X")

	-- Bidirectional and all windows
	vim.keymap.set({ "n", "v", "o" }, "s", function()
		leap.leap({
			target_windows = vim.tbl_filter(function(win)
				return vim.api.nvim_win_get_config(win).focusable
			end, vim.api.nvim_tabpage_list_wins(0)),
		})
	end, { silent = true, remap = false })
end

return M
