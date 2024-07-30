local M = {
	"MeanderingProgrammer/markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "quarto", "rmd" },
}

function M.config()
	local icons = require("icons")
	local block = icons.bar.vertical_block

	require("render-markdown").setup({
		render_modes = { "n", "no", "i", "v", "V", "^V", "r", "x", "c" },
		file_types = { "markdown", "quarto", "rmd" },

		heading = {
			-- Turn on / off heading icon & background rendering
			enabled = true,
			-- Turn on / off any sign column related rendering
			sign = false,
			-- Width of the heading background:
			--  block: width of the heading text
			--  full: full width of the window
			width = "block",
			-- Replaces '#+' of 'atx_h._marker'
			-- The number of '#' in the heading determines the 'level'
			-- The 'level' is used to index into the array using a cycle
			-- The result is left padded with spaces to hide any additional '#'
			icons = {
				block .. " ",
				block .. block .. " ",
				block .. block .. block .. " ",
				block .. block .. block .. block .. " ",
				block .. block .. block .. block .. block .. " ",
				block .. block .. block .. block .. block .. block .. " ",
			},
			-- Highlight for the heading icon and extends through the entire line
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
			-- The 'level' is used to index into the array using a clamp
			-- Highlight for the heading and sign icons
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH2",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH5",
				"RenderMarkdownH6",
			},
		},

		sign = {
			enabled = false,
		},

		code = {
			-- Turn on / off code block & inline code rendering
			enabled = true,
			-- Turn on / off any sign column related rendering
			sign = false,
			-- Determines how code blocks & inline code are rendered:
			--  none: disables all rendering
			--  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
			--  language: adds language icon to sign column if enabled and icon + name above code blocks
			--  full: normal + language
			style = "full",
			-- Width of the code block background:
			-- * full: full width of the window
			-- * block: width of the code block
			width = "block",
			-- Amount of padding to add to the left of code blocks
			left_pad = 0,
			-- Amount of padding to add to the right of code blocks
			right_pad = 2,
			-- Determins how the top / bottom of code block are rendered:
			--  thick: use the same highlight as the code body
			--  thin: when lines are empty overlay the above & below icons
			border = "thin",
			-- Used above code blocks for thin border
			above = icons.bar.lower_horizontal_thick,
			-- Used below code blocks for thin border
			below = icons.bar.upper_horizontal_thick,
			-- Highlight for code blocks & inline code
			highlight = "RenderMarkdownCode",
		},

		bullet = {
			enabled = true,
			icons = { icons.small_circle },
			right_pad = 0,
		},

		overrides = {
			buftype = {
				-- Particularly for LSP hover
				nofile = {
					code = {
						enabled = true,
						sign = false,
						style = "normal",
						width = "full",
						left_pad = 0,
						right_pad = 0,
						border = "thick",
						highlight = "RenderMarkdownCodeNoFile",
					},
				},
			},
		},
	})

	local hls = require("highlights")
	local colors = hls.colors()
	hls.register_hls({
		RenderMarkdownH1 = { fg = colors.cyan_virtual_fg, bg = colors.cyan_virtual_bg, bold = true },
		RenderMarkdownH1Bg = { fg = colors.cyan_virtual_fg, bg = colors.cyan_virtual_bg, bold = true },
		RenderMarkdownH2 = { fg = colors.green_virtual_fg, bg = colors.green_virtual_bg, bold = true },
		RenderMarkdownH2Bg = { fg = colors.green_virtual_fg, bg = colors.green_virtual_bg, bold = true },
		RenderMarkdownH3 = { fg = colors.yellow_virtual_fg, bg = colors.yellow_virtual_bg, bold = true },
		RenderMarkdownH3Bg = { fg = colors.yellow_virtual_fg, bg = colors.yellow_virtual_bg, bold = true },
		RenderMarkdownH4 = { fg = colors.red_virtual_fg, bg = colors.red_virtual_bg, bold = true },
		RenderMarkdownH4Bg = { fg = colors.red_virtual_fg, bg = colors.red_virtual_bg, bold = true },
		RenderMarkdownH5 = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
		RenderMarkdownH5Bg = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
		RenderMarkdownH6 = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
		RenderMarkdownH6Bg = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
		-- RenderMarkdownCode = { bg = colors.statusline_bg },
		RenderMarkdownCodeNoFile = { bg = colors.statusline_bg },
	})
end

return M
