local M = {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = {
		"ToggleTerm",
		"ToggleTermToggleAll",
		"TermExec",
		"ToggleTermSendVisualSelection",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSetName",

		-- Custom terminals
		"Lazygit",
		"Mprocs",
	},
}

function M.init()
	vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Lazygit<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>Z", "<cmd>Mprocs<cr>", { noremap = true, silent = true })
end

function M.config()
	require("toggleterm").setup({
		shade_terminals = true,
		float_opts = {
			border = "single",
		},
	})

	local Terminal = require("toggleterm.terminal").Terminal

	-- Lazygit
	local lazygit = Terminal:new({
		cmd = "lazygit",
		dir = "git_dir",
		direction = "float",
		hidden = true,
	})

	function _lazygit_toggle()
		lazygit:toggle()
	end

	vim.api.nvim_create_user_command("Lazygit", "lua _lazygit_toggle()", {})

	-- Mprocs
	local mprocs = Terminal:new({
		cmd = "pm",
		-- dir = "git_dir",
		-- direction = "horizontal",
		-- hidden = true,
	})

	function _mprocs_toggle()
		mprocs:toggle()
	end

	vim.api.nvim_create_user_command("Mprocs", "lua _mprocs_toggle()", {})
end

return M
