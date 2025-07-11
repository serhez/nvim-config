local M = {
	"quarto-dev/quarto-nvim",
	dependencies = {
		"jmbuhr/otter.nvim",
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
		"Vigemus/iron.nvim",
		"benlubas/molten-nvim",
	},
	ft = { "markdown", "quarto", "rmd" },
}

vim.g.quarto_runner = "iron"

-- Global variable for suffix
local SAVE_SUFFIX = "_SAVEDDATA"

-- Create an ipynb file at the same path and with the same name than the quarto file.
local function current_file_with_extension(extension, suffix)
	local current_file = vim.fn.expand("%")
	local current_file_without_extension = current_file:match("(.+)%..+") or current_file
	return current_file_without_extension .. suffix .. "." .. extension
end

function M.init()
	require("mappings").register({
		-- NOTE: Now handled by markdown-preview
		--       (better functionality, such as cursor following and
		--       syncing without saving)
		-- { "<leader>m", group = "Markdown" },
		-- { "<leader>mp", "<cmd>QuartoPreview<cr>", desc = "Preview" },
		-- { "<leader>mP", "<cmd>QuartoClosePreview<cr>", desc = "Close preview" },

		{ "<leader>nn", "o<esc>O```python\r```<esc>O", desc = "New cell" },
		{ "<leader>nd", "o```\r\r```python<esc>kkk0", desc = "Divide cell" },
		{
			"<leader>nc",
			function()
				require("quarto.runner").run_cell()
			end,
			desc = "Run cell",
		},
		{
			"<leader>na",
			function()
				require("quarto.runner").run_all()
			end,
			desc = "Run all (current lang)",
		},
		{
			"<leader>nA",
			function()
				require("quarto.runner").run_all(true)
			end,
			desc = "Run all (all langs)",
		},
		{
			"<leader>nj",
			function()
				require("quarto.runner").run_below()
			end,
			desc = "Run below",
		},
		{
			"<leader>nk",
			function()
				require("quarto.runner").run_above()
			end,
			desc = "Run above",
		},
		{
			"<leader>nl",
			function()
				require("quarto.runner").run_line()
			end,
			desc = "Run line",
		},
		{
			"<leader>nC",
			function()
				if vim.g.quarto_runner == "iron" then
					vim.cmd("IronRepl")
				else
					vim.notify(
						"Command line mode is only supported by the 'iron' runner",
						vim.log.levels.WARN,
						{ title = "Notebook" }
					)
				end
			end,
			desc = "Command line mode",
		},
		{
			"<leader>nr",
			function()
				if vim.g.quarto_runner == "iron" then
					vim.cmd("IronRestart")
				elseif vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenRestart")
				end
			end,
			desc = "Restart",
		},
		{
			"<leader>ns",
			function()
				if vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenInterrupt")
				else
					vim.notify(
						"Stop execution is only supported by the 'molten' runner",
						vim.log.levels.WARN,
						{ title = "Notebook" }
					)
				end
			end,
			desc = "Stop execution",
		},
		{
			"<leader>nS",
			function()
				if vim.g.quarto_runner == "iron" then
					require("iron.core").close_repl()
				elseif vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenDeinit")
				end
			end,
			desc = "Stop session",
		},
		{
			"<leader>no",
			function()
				if vim.g.quarto_runner == "iron" then
					vim.cmd("IronRepl")
				elseif vim.g.quarto_runner == "molten" then
					vim.cmd("zt<cmd>noautocmd MoltenEnterOutput<cr><cmd>noautocmd MoltenEnterOutput<cr>")
				end
			end,
			desc = "Open output",
		},
		{
			"<leader>nO",
			function()
				if vim.g.quarto_runner == "iron" then
					vim.cmd("IronHide")
				elseif vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenHideOutput")
				end
			end,
			desc = "Close output",
		},
		{
			"<leader>ne",
			function()
				if vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenSave " .. current_file_with_extension("json", SAVE_SUFFIX))
				else
					vim.notify(
						"Export is only supported by the 'molten' runner",
						vim.log.levels.WARN,
						{ title = "Notebook" }
					)
				end
			end,
			desc = "Export",
		},
		{
			"<leader>ni",
			function()
				if vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenLoad " .. current_file_with_extension("json", SAVE_SUFFIX))
				else
					vim.notify(
						"Import is only supported by the 'molten' runner",
						vim.log.levels.WARN,
						{ title = "Notebook" }
					)
				end
			end,
			desc = "Import",
		},
		{
			"<leader>nI",
			function()
				if vim.g.quarto_runner == "molten" then
					vim.cmd("MoltenImagePopup")
				else
					vim.notify(
						"Insert image is only supported by the 'molten' runner",
						vim.log.levels.WARN,
						{ title = "Notebook" }
					)
				end
			end,
			desc = "Open image",
		},
		{
			"<leader>nm",
			group = "Select code runner method",
		},
		{
			"<leader>nmr",
			function()
				vim.g.quarto_runner = "iron"
				vim.notify("Code runner set to 'iron'", vim.log.levels.INFO, { title = "Notebook" })
			end,
			desc = "Iron",
		},
		{
			"<leader>nmm",
			function()
				vim.g.quarto_runner = "molten"
				vim.notify("Code runner set to 'molten'", vim.log.levels.INFO, { title = "Notebook" })
			end,
			desc = "Molten",
		},
	})
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
			default_method = function(cell, ignore_cols)
				require("quarto.runner." .. vim.g.quarto_runner).run(cell, ignore_cols)
			end,
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
