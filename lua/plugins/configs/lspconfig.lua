local M = {
	"neovim/nvim-lspconfig",
}

function M.init()
	require("mappings").register({
		{ "<leader>cf", "<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.format()<cr>", desc = "Format" },
		{
			"<leader>cF",
			"<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.toggle_auto_format()<cr>",
			desc = "Toggle auto-format",
		},
	})
end

return M
