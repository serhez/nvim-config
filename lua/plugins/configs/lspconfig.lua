local mappings = require("mappings")

local M = {
	"neovim/nvim-lspconfig",
}

function M.init()
	mappings.register_normal({
		c = {
			d = {
				l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Line" },
				c = { '<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<cr>', "Cursor" },
			},
			f = { "<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.format()<cr>", "Format" },
			F = {
				"<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.toggle_auto_format()<cr>",
				"Toggle auto-format",
			},
			u = { "Usages" },
		},
	})
end

return M
