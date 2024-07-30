local M = {
	"quarto-dev/quarto-nvim",
	dependencies = {
		"jmbuhr/otter.nvim",
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
	},
	ft = { "markdown", "quarto", "rmd" },
}

function M.init()
	require("mappings").register({
		{ "<leader>m", group = "Markdown" },
		{ "<leader>mp", "<cmd>QuartoPreview<cr>", desc = "Preview" },
		{ "<leader>mP", "<cmd>QuartoClosePreview<cr>", desc = "Close preview" },

		{ "<leader>n", group = "Notebook" },
		{ "<leader>nn", "o<esc>O```python\r```<esc>O", desc = "New cell" },
		{ "<leader>nd", "o```\r\r```python<esc>kkk0", desc = "Divide cell" },
		{
			"<leader>nr",
			function()
				require("quarto.runner").run_cell()
			end,
			desc = "Run cell",
		},

		{ "<leader>nR", group = "Run" },
		{
			"<leader>nRa",
			function()
				require("quarto.runner").run_all()
			end,
			desc = "All cells",
		},
		{
			"<leader>nRA",
			function()
				require("quarto.runner").run_all(true)
			end,
			desc = "All cells (all langs)",
		},
		{
			"<leader>nRj",
			function()
				require("quarto.runner").run_below()
			end,
			desc = "Cell and below",
		},
		{
			"<leader>nRk",
			function()
				require("quarto.runner").run_above()
			end,
			desc = "Cell and above",
		},
		{
			"<leader>nRl",
			function()
				require("quarto.runner").run_line()
			end,
			desc = "Line",
		},
	})
end

local function keys(str)
	return function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
	end
end

function M.config()
	require("quarto").setup({
		closePreviewOnExit = true,
		lspFeatures = {
			enabled = true,
			languages = { "r", "python", "julia", "rust", "bash" },
			chunks = "all", -- 'curly' or 'all'
			diagnostics = {
				enabled = true,
				triggers = { "InsertLeave" },
			},
			completion = {
				enabled = true,
			},
		},
		codeRunner = {
			enabled = true,
			default_method = "molten",
		},
		keymap = {
			hover = "K",
			definition = "gd",
			rename = "<leader>cn",
			references = "gr",
			format = "<leader>cf",
		},
	})
end

return M
