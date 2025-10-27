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
end

return M
