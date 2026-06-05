local M = {
	"kylechui/nvim-surround",
	event = "VeryLazy",
}

function M.config()
	vim.g.nvim_surround_no_normal_mappings = true
	vim.g.nvim_surround_no_visual_mappings = true

	vim.keymap.set("n", "s", "<Plug>(nvim-surround-normal)", {
		desc = "Add a surrounding pair around a motion (normal mode)",
	})
	vim.keymap.set("n", "ss", "<Plug>(nvim-surround-normal-cur)", {
		desc = "Add a surrounding pair around the current line (normal mode)",
	})
	vim.keymap.set("n", "S", "<Plug>(nvim-surround-normal-line)", {
		desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
	})
	vim.keymap.set("n", "SS", "<Plug>(nvim-surround-normal-cur-line)", {
		desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
	})
	vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", {
		desc = "Add a surrounding pair around a visual selection",
	})
	vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual-line)", {
		desc = "Add a surrounding pair around a visual selection, on new lines",
	})
end

return M
