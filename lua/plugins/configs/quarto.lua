local M = {
	"quarto-dev/quarto-nvim",
	dependencies = {
		"jmbuhr/otter.nvim",
		"neovim/nvim-lspconfig",
		"anuvyklack/hydra.nvim",
	},
	ft = { "markdown", "quarto", "rmd" },
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		l = {
			m = {
				name = "Markdown",
				p = { "<cmd>QuartoPreview<cr>", "Preview" },
				P = { "<cmd>QuartoClosePreview<cr>", "Close preview" },
			},
		},
		n = {
			n = { "o<esc>o```{}\r```<esc>o<esc><up><up><right><right><right>a", "New code cell" },
			s = { "o```\r\r```{}<left>", "Split code cell" },
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
					"Run all cells",
				},
				A = {
					function()
						require("quarto.runner").run_all(true)
					end,
					"Run all cells (all langs)",
				},
				d = {
					function()
						require("quarto.runner").run_below()
					end,
					"Run cell and below",
				},
				l = {
					function()
						require("quarto.runner").run_line()
					end,
					"Run line",
				},
				u = {
					function()
						require("quarto.runner").run_above()
					end,
					"Run cell and above",
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
			keymap = {
				hover = "K",
				definition = "gd",
				rename = "<leader>cn",
				references = "gr",
				format = "<leader>cf",
			},
		},
		codeRunner = {
			enabled = true,
			default_method = "molten",
		},
	})

	require("hydra")({
		name = "QuartoNavigator",
		hint = false,
		config = {
			color = "pink",
			invoke_on_body = true,
			hint = false,
		},
		mode = { "n" },
		body = "<localleader>j",
		heads = {
			{ "j", keys("]b"), { desc = "↓", remap = true, noremap = false } },
			{ "k", keys("[b"), { desc = "↑", remap = true, noremap = false } },
			{ "o", keys("/```<CR>:nohl<CR>o<CR>`<c-j>"), { desc = "new cell ↓", exit = true } },
			{ "O", keys("?```{<CR>:nohl<CR><leader>kO<CR>`<c-j>"), { desc = "new cell ↑", exit = true } },
			{ "l", ":QuartoSend<CR>", { desc = "run" } },
			{ "s", ":noautocmd MoltenEnterOutput<CR>", { desc = "show" } },
			{ "h", ":MoltenHideOutput<CR>", { desc = "hide" } },
			{ "a", ":QuartoSendAbove<CR>", { desc = "run above" } },
			{ "<esc>", nil, { exit = true } },
			{ "q", nil, { exit = true } },
		},
	})
end

return M
