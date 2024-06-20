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
		m = {
			name = "Markdown",
			p = { "<cmd>QuartoPreview<cr>", "Preview" },
			P = { "<cmd>QuartoClosePreview<cr>", "Close preview" },
		},
		n = {
			n = { "o<esc>O```python\r```<esc>O", "New cell" },
			d = { "o```\r\r```python<esc>kkk0", "Divide cell" },
			r = {
				function()
					require("quarto.runner").run_cell()
				end,
				"Run cell",
			},
			R = {
				name = "Run",
				a = {
					function()
						require("quarto.runner").run_all()
					end,
					"All cells",
				},
				A = {
					function()
						require("quarto.runner").run_all(true)
					end,
					"All cells (all langs)",
				},
				j = {
					function()
						require("quarto.runner").run_below()
					end,
					"Cell and below",
				},
				k = {
					function()
						require("quarto.runner").run_above()
					end,
					"Cell and above",
				},
				l = {
					function()
						require("quarto.runner").run_line()
					end,
					"Line",
				},
			},
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
