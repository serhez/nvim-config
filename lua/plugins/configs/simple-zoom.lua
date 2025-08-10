local M = {
	"fasterius/simple-zoom.nvim",
}

function M.init()
	require("mappings").register({
		{
			"<leader>z",
			function()
				require("simple-zoom").toggle_zoom()
			end,
			desc = "Toggle window zoom",
		},
	})
end

function M.config()
	require("simple-zoom").setup({
		hide_tabline = false,
	})
end

return M
