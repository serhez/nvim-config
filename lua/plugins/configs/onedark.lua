local M = {
	"olimorris/onedarkpro.nvim",
	priority = 1000, -- Ensure it loads first
}

function M.config()
	require("onedarkpro").setup({
		filetypes = {
			all = true,
		},
		plugins = {
			all = true,
		},
	})
end

return M
