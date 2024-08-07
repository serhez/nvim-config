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
	mappings.register({
		{ "<leader>ch", "<cmd>HiMyWordsToggle<cr>", desc = "Highlight word (toggle)" },
		{ "<leader>cH", "<cmd>HiMyWordsClear<cr>", desc = "Clear highlights" },
	})
end

function M.config()
	local c = hls.colors()

	require("hi-my-words").setup({
		silent = false,
		hl_grps = {
			{
				"HiMyWordsHLG0",
				{ fg = c.bg, bg = c.info_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG1",
				{ fg = c.bg, bg = c.hint_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG2",
				{ fg = c.bg, bg = c.identifier_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG3",
				{ fg = c.bg, bg = c.warn_fg, bold = true, italic = false },
			},
			{
				"HiMyWordsHLG4",
				{ fg = c.bg, bg = c.error_fg, bold = true, italic = false },
			},
		},
	})
end

return M
