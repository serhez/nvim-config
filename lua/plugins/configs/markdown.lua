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

	require("render-markdown").setup({
		render_modes = { "n", "no", "i", "v", "V", "^V", "r", "x", "c" },
		file_types = { "markdown", "quarto", "rmd" },

		heading = {
			-- Turn on / off heading icon & background rendering
			enabled = true,
			-- Turn on / off any sign column related rendering
			sign = false,
			-- Replaces '#+' of 'atx_h._marker'
			-- The number of '#' in the heading determines the 'level'
			-- The 'level' is used to index into the array using a cycle
			-- The result is left padded with spaces to hide any additional '#'
			-- icons = {
			-- 	"󰼛 ",
			-- 	"󰼛󰼛 ",
			-- 	"󰼛󰼛󰼛 ",
			-- 	"󰼛󰼛󰼛󰼛 ",
			-- 	"󰼛󰼛󰼛󰼛󰼛 ",
			-- 	"󰼛󰼛󰼛󰼛󰼛󰼛 ",
			-- },
			icons = {
				" ",
				" ",
				" ",
				" ",
				" ",
				" ",
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
			-- Amount of padding to add to the left of code blocks
			left_pad = 0,
			-- Determins how the top / bottom of code block are rendered:
			--  thick: use the same highlight as the code body
			--  thin: when lines are empty overlay the above & below icons
			border = "thick",
			-- Used above code blocks for thin border
			above = icons.bar.vertical_block,
			-- Used below code blocks for thin border
			below = icons.bar.vertical_block,
			-- Highlight for code blocks & inline code
			highlight = "RenderMarkdownCode",
		},

		bullet = {
			enabled = true,
			icons = { icons.small_circle .. " " },
		},
	})

	local hls = require("highlights")
	local common_hls = hls.common_hls()
	hls.register_hls({
		RenderMarkdownH1 = common_hls.cyan_virtual,
		RenderMarkdownH1Bg = common_hls.cyan_virtual,
		RenderMarkdownH2 = common_hls.green_virtual,
		RenderMarkdownH2Bg = common_hls.green_virtual,
		RenderMarkdownH3 = common_hls.yellow_virtual,
		RenderMarkdownH3Bg = common_hls.yellow_virtual,
		RenderMarkdownH4 = common_hls.red_virtual,
		RenderMarkdownH4Bg = common_hls.red_virtual,
		RenderMarkdownH5 = common_hls.blue_virtual,
		RenderMarkdownH5Bg = common_hls.blue_virtual,
		RenderMarkdownH6 = common_hls.blue_virtual,
		RenderMarkdownH6Bg = common_hls.blue_virtual,
	})
end

return M
