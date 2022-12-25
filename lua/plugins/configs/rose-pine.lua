local M = {
    "rose-pine/neovim",
    name = "rose-pine",
    version = "v1.*",
}

function M.config()
    require("rose-pine").setup({
		--- @usage 'main' | 'moon'
		dark_variant = "main",
		bold_vert_split = false,
		dim_nc_background = false,
		disable_background = false,
		disable_float_background = false,
		disable_italics = false,
	})
end

return M