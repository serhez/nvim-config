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
			aerial = false,
			barbar = false,
			beacon = false,
			cmp = true,
			coc_nvim = false,
			dashboard = false,
			fern = false,
			fidget = false,
			gitgutter = false,
			gitsigns = true,
			harpoon = true,
			hop = false,
			illuminate = true,
			leap = true,
			lightspeed = false,
			lsp_saga = false,
			lsp_trouble = true,
			markdown = true,
			mason = true,
			mini = false,
			neogit = false,
			neotest = true,
			neotree = true,
			noice = true,
			notify = false,
			nvimtree = false,
			overseer = false,
			pounce = false,
			sandwich = false,
			semantic_tokens = false,
			symbols_outline = false,
			telekasten = false,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			ts_rainbow = false,
			ts_rainbow2 = false,
			vim_sneak = false,
			vimwiki = false,
			which_key = true,

			-- Special integrations, see https://github.com/catppuccin/nvim#special-integrations
			barbecue = {
				dim_dirname = true,
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
				enabled = false,
				custom_bg = "NONE",
			},
		},
	})
end

return M
