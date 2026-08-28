local M = {
	"RRethy/vim-illuminate",
	event = "CursorMoved",
}

function M.config()
	require("illuminate").configure({
		-- The LSP provider sends and cancels a documentHighlight request on every
		-- CursorMoved before the display delay is applied. Regex runs locally only
		-- after the delay, so it cannot create request churn while scrolling.
		providers = { "regex" },
		-- delay: delay in milliseconds
		delay = 250,
		large_file_cutoff = 2000,
		large_file_overrides = {
			providers = { "regex" },
			delay = 500,
			under_cursor = false,
		},
		filetypes_denylist = {
			"dropbar_menu",
			"neo-tree",
			"TelescopePrompt",
		},
	})
end

return M
