local M = {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	enabled = false,
}

function M.init()
	require("mappings").register({
		{ "<leader>m", group = "Markdown" },
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Preview (toggle)" },
	})
end

return M
