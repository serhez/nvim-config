local mappings = require("mappings")

local M = {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
}

function M.init()
	vim.api.nvim_set_keymap(
		"n",
		"<TAB>",
		"<cmd>lua require('harpoon.ui').nav_next()<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<S-TAB>",
		"<cmd>lua require('harpoon.ui').nav_prev()<cr>",
		{ noremap = true, silent = true }
	)

	mappings.register_normal({
		f = {
			h = { "<cmd>Telescope harpoon marks<cr>", "Harpoon" },
		},
		h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon menu" },
		H = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Harpoon file" },
	})
end

function M.confit()
	require("harpoon").setup({
		-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
		save_on_toggle = true,

		-- saves the harpoon file upon every change. disabling is unrecommended.
		save_on_change = true,

		-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
		enter_on_sendcmd = false,

		-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
		tmux_autoclose_windows = false,

		-- filetypes that you want to prevent from adding to the harpoon list menu.
		excluded_filetypes = { "harpoon" },

		-- set marks specific to each git branch inside git repository
		mark_branch = true,
	})

	local present, telescope = pcall(require, "telescope")
	if present then
		telescope.load_extension("harpoon")
	end

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		HarpoonWindow = { bg = c.statusline_bg },
		HarpoonBorder = { fg = c.statusline_bg, bg = c.statusline_bg },
	})
end

return M
