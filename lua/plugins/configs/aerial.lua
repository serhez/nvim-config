local M = {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "AerialToggle",
	enabled = false,
}

function M.init()
	require("mappings").register_normal({
		A = { "<cmd>AerialToggle!<cr>", "Outline (alt)" },
	})
end

function M.config()
	require("aerial").setup({})
end

return M
