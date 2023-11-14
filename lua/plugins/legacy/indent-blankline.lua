local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
}

function M.config()
	local icons = require("icons")

	require("ibl").setup({
		indent = {
			char = icons.bar.vertical_center_thin,
		},
		whitespace = {
			remove_blankline_trail = true,
		},
		scope = {
			enabled = true,
			char = icons.bar.vertical_center_thin,
			show_start = false,
			show_end = false,
			show_exact_scope = true,
			injected_languages = true,
			highlight = "IblScope",
			priority = 1024,
		},
	})
end

return M
