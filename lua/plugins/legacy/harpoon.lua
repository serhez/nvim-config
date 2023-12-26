local M = {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
}

function M.init()
	vim.api.nvim_set_keymap(
		"n",
		"]a",
		"<cmd>lua require('harpoon'):list():next()<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"[a",
		"<cmd>lua require('harpoon'):list():prev()<cr>",
		{ noremap = true, silent = true }
	)

	local mappings = require("mappings")
	mappings.register_normal({
		h = { "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", "Harpoon menu" },
		H = { "<cmd>lua require('harpoon'):list():append()<cr>", "Harpoon file" },
	})
end

function M.confit()
	require("harpoon"):setup({
		-- any time the ui menu is closed then we will save the state back to the backing list, not to the fs
		save_on_toggle = true,

		-- any time the ui menu is closed then the state of the list will be sync'd back to the fs
		sync_on_ui_close = true,
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		HarpoonWindow = { bg = c.statusline_bg },
		HarpoonBorder = { fg = c.statusline_bg, bg = c.statusline_bg },
		HarpoonCurrentFile = { fg = c.cursor_line_fg, bg = c.cursor_line_bg },
	})
end

return M
