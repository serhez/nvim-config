local mappings = require("mappings")
local hls = require("highlights")

local M = {
	"dvoytik/hi-my-words.nvim",
	cmd = {
		"HiMyWordsToggle",
		"HiMyWordsClear",
	},
}

function M.init()
	mappings.register_normal({
		c = {
			h = {
				name = "Highlight",
				t = { "<cmd>HiMyWordsToggle<cr>", "Toggle word" },
				c = { "<cmd>HiMyWordsClear<cr>", "Clear" },
			},
		},
	})
end

function M.config()
	local c = hls.colors()

	require("hi-my-words").setup({
		silent = false,
		hl_grps = {
			{
				"HiMyWordsHLG0",
				{ fg = c.fg, bg = c.info_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG1",
				{ fg = c.fg, bg = c.hint_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG2",
				{ fg = c.fg, bg = c.identifier_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG3",
				{ fg = c.fg, bg = c.warn_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG4",
				{ fg = c.fg, bg = c.error_fg, bold = true, italic = false },
			},
		},
	})
end

return M
