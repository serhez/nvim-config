local hls = require("highlights")

local M = {
	"RRethy/vim-illuminate",
	event = "CursorMoved",
}

function M.config()
	require("illuminate").configure({
		-- delay: delay in milliseconds
		delay = 0,
	})

	local c = hls.colors()
	hls.register_hls({
		IlluminatedWordRead = { bg = c.cursor_line_bg, underline = true },
		IlluminatedWordText = { bg = c.cursor_line_bg, underline = true },
		IlluminatedWordWrite = { bg = c.cursor_line_bg, underline = true },
	})
end

return M
