local M = {
	"toppair/peek.nvim",
	build = "deno task --quiet build:fast",
}

function M.init()
	require("mappings").register({
		{ "<leader>m", group = "Markdown" },
		{
			"<leader>mp",
			function()
				local peek = require("peek")
				if peek.is_open() then
					peek.close()
				else
					peek.open()
				end
			end,
			desc = "Preview (toggle)",
		},
	})
end

function M.config()
	require("peek").setup({
		theme = "light",
		filetype = { "markdown", "quarto" },

		-- "webview", "browser", or specific browser with arguments
		-- app = "webview",
		app = { "arc", "--new-window" },
	})
end

return M
