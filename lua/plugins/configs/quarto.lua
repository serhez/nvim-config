local M = {
	"quarto-dev/quarto-nvim",
	dependencies = {
		"jmbuhr/otter.nvim",
		"neovim/nvim-lspconfig",
	},
	ft = { "markdown", "quarto", "rmd" },
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		M = {
			name = "Markdown",
			p = { "<cmd>QuartoPreview<cr>", "Preview" },
			P = { "<cmd>QuartoClosePreview<cr>", "Close preview" },
		},
	})
end

function M.config()
	require("quarto").setup({
		closePreviewOnExit = true,
		lspFeatures = {
			enabled = true,
			languages = { "r", "python", "julia" },
			diagnostics = {
				enabled = true,
				triggers = { "BufWrite" },
			},
			completion = {
				enabled = true,
			},
		},
	})
end

return M
