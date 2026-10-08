-- Editor half of herdr's vim-aware pane navigation.
--
-- Herdr binds <M-h/j/k/l> to the vim-herdr-navigation plugin, which forwards
-- <C-h/j/k/l> into a pane running vim/nvim instead of stealing the key. Those
-- are the chords mapped here: move between Neovim splits, and hand focus back
-- to herdr once there is no split left in that direction.
--
-- Outside herdr this defers to Navigator.nvim, so the <M-h/j/k/l> tmux setup
-- is untouched.

local multiplexer = require("multiplexer")

local function navigate(wincmd, dir)
	local from = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. wincmd)
	if vim.api.nvim_get_current_win() ~= from then
		return
	end

	local pane = vim.env.HERDR_PANE_ID
	if pane ~= nil and pane ~= "" then
		-- --current resolves to the server's focused pane, which need not be
		-- the one this Neovim runs in, so target the pane explicitly.
		vim.fn.system({ multiplexer.herdr_bin(), "pane", "focus", "--direction", dir, "--pane", pane })
		return
	end

	local command = "Navigator" .. dir:sub(1, 1):upper() .. dir:sub(2)
	pcall(vim.cmd, command)
end

local directions = {
	{ "<C-h>", "h", "left" },
	{ "<C-j>", "j", "down" },
	{ "<C-k>", "k", "up" },
	{ "<C-l>", "l", "right" },
}

for _, spec in ipairs(directions) do
	local lhs, wincmd, dir = spec[1], spec[2], spec[3]
	vim.keymap.set({ "n", "t", "i" }, lhs, function()
		navigate(wincmd, dir)
	end, { silent = true, desc = "Navigate " .. dir .. " (herdr)" })
end
