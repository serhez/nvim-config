local M = {
	"rose-pine/neovim",
	name = "rose-pine",
}

function M.config()
	require("rose-pine").setup({
		--- @usage 'main' | 'moon'
		dark_variant = "main",
		bold_vert_split = false,
		dim_nc_background = false,
		disable_background = false,
		disable_float_background = false,
		disable_italics = true,

		highlight_groups = {
			Conceal = {
				fg = "muted",
				background = "base",
			},
		},
	})
end

return M
