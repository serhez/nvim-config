local M = {
	"RRethy/vim-illuminate",
	event = "CursorMoved",
}

function M.config()
	require("illuminate").configure({
		-- delay: delay in milliseconds
		delay = 0,
	})
end

return M
