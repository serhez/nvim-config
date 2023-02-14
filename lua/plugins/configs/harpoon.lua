local mappings = require("mappings")

local M = {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	-- event = "VeryLazy", -- FIX: Use cmd instead
	cmd = {
		"HarpoonMark",
		"HarpoonNext",
		"HarpoonPrev",
		"HarpoonMenu",
		"Telescope harpoon marks",
	},
}

function M.init()
	vim.api.nvim_create_user_command("HarpoonMark", "lua require('harpoon.mark').add_file()", {})
	vim.api.nvim_create_user_command("HarpoonNext", "lua require('harpoon.ui').nav_next()", {})
	vim.api.nvim_create_user_command("HarpoonPrev", "lua require('harpoon.ui').nav_prev()", {})
	vim.api.nvim_create_user_command("HarpoonMenu", "lua require('harpoon.ui').toggle_quick_menu()", {})

	mappings.register_normal({
		f = {
			h = { "<cmd>Telescope harpoon marks<cr>", "Harpoon" },
		},
		h = {
			name = "Harpoon",
			f = { "<cmd>HarpoonMark<cr>", "Mark file" },
			n = { "<cmd>HarpoonNext<cr>", "Next file" },
			p = { "<cmd>HarpoonPrev<cr>", "Previous file" },
			m = { "<cmd>Telescope harpoon marks<cr>", "Menu" },
		},
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
end

return M
