local M = {
	"neovim/nvim-lspconfig",
}

function M.init()
	require("mappings").register({
		{ "<leader>cf", "<cmd>lua require'plugins.configs.mason-lspconfig.formatting'.format()<cr>", desc = "Format" },
		{
			"<leader>cF",
			function()
				local enabled = require("plugins.configs.mason-lspconfig.formatting").toggle_auto_format()
				vim.notify(
					(enabled and "Enabled" or "Disabled") .. " auto-formatting",
					vim.log.levels.INFO,
					{ title = "Auto-formatting" }
				)
			end,
			desc = "Toggle auto-format",
		},
	})
end

return M
