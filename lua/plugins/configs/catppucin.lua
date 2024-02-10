local M = {
	"catppuccin/nvim",
	name = "catppuccin",
}

function M.config()
	require("catppuccin").setup({
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		transparent_background = false,

		integrations = {
			cmp = true,
			fidget = true,
			gitsigns = true,
			headlines = true,
			illuminate = true,
			leap = true,
			lsp_trouble = true,
			markdown = true,
			mason = true,
			mini = true,
			neogit = true,
			neotest = true,
			neotree = true,
			noice = true,
			symbols_outline = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,

			-- Special integrations, see https://github.com/catppuccin/nvim#special-integrations
			dropbar = {
				enabled = true,
				color_mode = false, -- enable color for kind's texts, not just kind's icons
			},
			barbecue = {
				dim_dirname = true,
				bold_basename = true,
				dim_context = false,
			},
			dap = {
				enabled = true,
				enable_ui = true,
			},
			indent_blankline = {
				enabled = true,
				colored_indent_levels = false,
			},
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			navic = {
				enabled = true,
				custom_bg = "NONE",
			},
		},
	})
end

return M
