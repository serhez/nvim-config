local M = {
	"luckasRanarison/nvim-devdocs",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = {
		"DevdocsFetch",
		"DevdocsInstall",
		"DevdocsUninstall",
		"DevdocsOpen",
		"DevdocsOpenFloat",
		"DevdocsOpenCurrent",
		"DevdocsOpenCurrentFloat",
		"DevdocsUpdate",
		"DevdocsUpdateAll",
	},
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		D = {
			name = "Docs",
			i = { "<cmd>DevdocsInstall ", "Install" },
			f = { "<cmd>DevdocsFetch<cr>", "Fetch" },
			o = { "<cmd>DevdocsOpenCurrentFloat<cr>", "Open (current)" },
			O = { "<cmd>DevdocsOpenFloat ", "Open (choose)" },
			u = { "<cmd>DevdocsUpdateAll<cr>", "Update all" },
			U = { "<cmd>DevdocsUninstall ", "Uninstall" },
		},
	})
end

function M.config()
	require("nvim-devdocs").setup({
		dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
		telescope = { theme = "ivy" }, -- passed to the telescope picker
		wrap = true, -- text wrap, only applies to floating window
		previewer_cmd = "glow", -- for example: "glow"
		cmd_args = { "-s", "dark", "-w", "80" }, -- example using glow: { "-s", "dark", "-w", "80" }
		cmd_ignore = {}, -- ignore cmd rendering for the listed docs
		picker_cmd = false, -- use cmd previewer in picker preview
		picker_cmd_args = { "-p" }, -- example using glow: { "-p" }
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"css",
			"go",
			"git",
			"html",
			"http",
			"javascript",
			"latex",
			"markdown",
			"pytorch",
			"python-3.9",
			"python-3.10",
			"python-3.11",
			"react",
			"svelte",
			"typescript",
			"vue-3",
			"tailwindcss",
		}, -- get automatically installed
	})
end

return M
