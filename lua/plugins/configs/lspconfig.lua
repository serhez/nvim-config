local mappings = require("mappings")

local M = {
	"neovim/nvim-lspconfig",
}

function M.init()
	mappings.register_normal({
		c = {
			f = { "<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.format()<cr>", "Format" },
			F = {
				"<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.toggle_auto_format()<cr>",
				"Toggle auto-format",
			},
		},
	})
end

return M
