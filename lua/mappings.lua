local M = {}

function M.register(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.add(mappings)
	end
end

function M.setup()
	-- Leader
	vim.g.mapleader = " "

	-- Disable native keybindings
	vim.keymap.set("n", "q", "<Nop>")

	-- Incrementing and decrementing
	vim.cmd("set nrformats=")

	-- JKL; to HJKL in normal mode (home row)
	vim.keymap.set({ "n", "v" }, "j", "h")
	vim.keymap.set({ "n", "v" }, "k", "j")
	vim.keymap.set({ "n", "v" }, "l", "k")
	vim.keymap.set({ "n", "v" }, ";", "l")
	-- vim.keymap.set({ "n", "v" }, "h", ";")

	-- Respect wrapping with jk navigation
	vim.cmd("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
	vim.cmd("nnoremap <expr> l v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

	-- NOTE: Additional critical mappings are set in the `which-key` plugin's config,
	--       as we want to register using `M.register` only once that plugin is loaded.
	--       If you remove `which-key`, you should move those mappings here.
end

return M
