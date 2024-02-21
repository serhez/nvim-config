local M = {
	"rasulomaroff/reactive.nvim",
	event = "BufRead",
}

function M.config()
	require("reactive").setup({
		load = { "catppuccin-macchiato-cursor", "catppuccin-macchiato-cursorline" },
		-- builtin = {
		-- 	cursorline = true,
		-- 	cursor = true,
		-- 	modemsg = true,
		-- },
	})
end

return M
