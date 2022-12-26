local mappings = require("mappings")

local M = {
	"neovim/nvim-lspconfig",
}

function M.init()
	mappings.register_normal({
		c = {
			d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Diagnostics (line)" },
			D = {
				'<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<cr>',
				"Diagnostics (cursor)",
			},
			f = { "<cmd>lua require'lsp.formatting'.format()<cr>", "Format" },
			F = { "<cmd>lua require'lsp.formatting'.toggle_auto_format()<cr>", "Toggle auto-format" },
			u = { "Usages" },
		},
	})
end

return M
