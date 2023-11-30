local mappings = require("mappings")

local M = {
	"akinsho/toggleterm.nvim",
	cmd = {
		"ToggleTerm",
		"ToggleTermToggleAll",
		"TermExec",
		"ToggleTermSendVisualSelection",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSetName",

		-- Custom terminals
		-- "Lazygit",
		"Mprocs",
	},
}

function M.init()
	mappings.register_normal({
		t = {
			n = { ":ToggleTermSetName ", "Change name" },
			s = { ":ToggleTermSendCurrentLine ", "Send line" },
			t = { "<cmd>ToggleTerm<cr>", "Toggle last" },
			T = { "<cmd>ToggleTermToggleAll<cr>", "Toggle all" },
		},
		p = {
			p = { "<cmd>Mprocs<cr>", "Panel" },
		},
		-- g = {
		-- 	p = { "<cmd>Lazygit<cr>", "Panel" },
		-- },
	})
	mappings.register_visual({
		t = {
			s = { ":ToggleTermSendVisualLines ", "Send selected lines" },
		},
	})
end

function M.config()
	require("toggleterm").setup({
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		autochdir = true,
		shade_terminals = true,
		float_opts = {
			border = "none",
		},
		direction = "vertical",
	})

	local Terminal = require("toggleterm.terminal").Terminal

	-- Lazygit
	-- local lazygit = Terminal:new({
	-- 	cmd = "lazygit",
	-- 	dir = "git_dir",
	-- 	direction = "float",
	-- 	hidden = true,
	-- })
	--
	-- function _lazygit_toggle()
	-- 	lazygit:toggle()
	-- end

	-- vim.api.nvim_create_user_command("Lazygit", "lua _lazygit_toggle()", {})

	-- Mprocs
	local mprocs = Terminal:new({
		cmd = "mprocs",
		dir = "git_dir",
		direction = "horizontal",
		hidden = true,
	})

	function _mprocs_toggle()
		mprocs:toggle()
	end

	vim.api.nvim_create_user_command("Mprocs", "lua _mprocs_toggle()", {})
end

return M
