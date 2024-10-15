local M = {
	"shortcuts/no-neck-pain.nvim",
	cmd = "NoNeckPain",
}

function M.init()
	require("mappings").register({
		{ "<leader>z", group = "Zen mode" },
		{ "<leader>zt", "<cmd>NoNeckPain<cr>", desc = "Toggle" },
		{ "<leader>zh", "<cmd>NoNeckPainToggleLeftSide<cr>", desc = "Toggle left side" },
		{ "<leader>zl", "<cmd>NoNeckPainToggleRightSide<cr>", desc = "Toggle right side" },
		{ "<leader>zr", ":NoNeckPainResize ", desc = "Resize" },
		{ "<leader>zw", "<cmd>NoNeckPainWidthUp<cr>", desc = "Wider" },
		{ "<leader>zW", "<cmd>NoNeckPainWidthDown<cr>", desc = "Less wide" },
	})
end

function M.config()
	require("no-neck-pain").setup({
		width = 125,

		buffers = {
			-- When `true`, the side buffers will be named `no-neck-pain-left` and `no-neck-pain-right` respectively
			-- setNames = true,

			wo = {
				cursorline = false,
				cursorcolumn = false,
				colorcolumn = "0",
				number = false,
				relativenumber = false,
				foldenable = false,
				list = false,
				wrap = true,
				linebreak = true,
			},

			bo = {
				filetype = "no-neck-pain",
				buftype = "nofile",
			},

			left = {
				scratchPad = {
					-- When `true`, automatically sets the following options to the side buffers:
					enabled = true,
					-- The path to the file to save the scratchPad content to and load it in the buffer.
					pathToFile = "~/.local/share/nvim/no-neck-pain_scratchpad_left.qmd",
				},
			},
			right = {
				scratchPad = {
					-- When `true`, automatically sets the following options to the side buffers:
					enabled = true,
					-- The path to the file to save the scratchPad content to and load it in the buffer.
					pathToFile = "~/.local/share/nvim/no-neck-pain_scratchpad_right.qmd",
				},
			},
		},
	})
end

return M
