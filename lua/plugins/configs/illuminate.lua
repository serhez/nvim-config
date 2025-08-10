local hls = require("highlights")

local M = {
	"RRethy/vim-illuminate",
	event = "CursorMoved",
}

function M.config()
	require("illuminate").configure({
		-- delay: delay in milliseconds
		delay = 250,
		filetypes_denylist = {
			"dropbar_menu",
			"neo-tree",
			"TelescopePrompt",
		},
	})

	local c = hls.colors()
	hls.register_hls({
		IlluminatedWordRead = { bg = c.folded_bg, underline = false },
		IlluminatedWordText = { bg = c.folded_bg, underline = false },
		IlluminatedWordWrite = { bg = c.folded_bg, underline = false },
	})
end

return M
