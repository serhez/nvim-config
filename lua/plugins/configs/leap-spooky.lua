local M = {
	"ggandor/leap-spooky.nvim",
}

function M.config()
	require("leap-spooky").setup({
		paste_on_remote_yank = false,
		affixes = {
			-- These will generate mappings for all native text objects, like:
			-- (ir|ar|iR|aR|im|am|iM|aM){obj}.
			-- Special line objects will also be added, by repeating the affixes.
			-- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
			-- window.
			-- You can also use 'rest' & 'move' as mnemonics.
			remote = { cross_window = "M" },
		},
	})
end

return M
