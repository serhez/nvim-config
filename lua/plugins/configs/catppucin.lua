local M = {
	"catppuccin/nvim",
	name = "catppuccin",
}

function M.config()
	require("catppuccin").setup({
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.01,
		},
		transparent_background = false,

		custom_highlights = function(colors)
			return {
				WinSeparator = { fg = colors.overlay1, bg = colors.none },
				CursorLineNr = { fg = colors.teal, bold = true },
			}
		end,

		integrations = {
			cmp = true,
			dap = true,
			dap_ui = true,
			fidget = true,
			gitsigns = true,
			headlines = true,
			flash = true,
			lsp_trouble = true,
			markdown = true,
			mason = true,
			neogit = true,
			neotest = true,
			-- neotree = true,
			noice = true,
			semantic_tokens = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
			window_picker = true,
			diffview = true,

			-- Special integrations, see https://github.com/catppuccin/nvim#special-integrations
			dropbar = {
				enabled = true,
				color_mode = true, -- enable color for kind's texts, not just kind's icons
			},
			illuminate = {
				enabled = true,
				lsp = false,
			},
			mini = {
				enabled = true,
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
				inlay_hints = {
					background = true,
				},
			},
			colorful_winsep = {
				enabled = true,
				color = "red",
			},
			indent_blankline = {
				enabled = true,
				scope_color = "sky",
				colored_indent_levels = false,
			},
		},
	})
end

return M
