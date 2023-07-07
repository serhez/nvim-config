local M = {
	"jackMort/ChatGPT.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	cmd = {
		"ChatGPT",
		"ChatGPTActAs",
		"ChatGPTEditWithInstructions",
	},
	enabled = false,
}

function M.init()
	local mappings = require("mappings")

	mappings.register_normal({
		a = {
			c = { "<cmd>ChatGPT<cr>", "Chat" },
			e = { "<cmd>ChatGPTEditWithInstructions<cr>", "Edit" },
			l = { "<cmd>ChatGPTActAs<cr>", "List" },
		},
	})

	mappings.register_visual({
		a = {
			e = { "<cmd>ChatGPTEditWithInstructions<cr>", "Edit" },
		},
	})
end

function M.config()
	local hls = require("highlights")

	require("chatgpt").setup({
		settings_window = {
			border = {
				style = "single",
			},
			win_options = {
				winhighlight = "Normal:FloatNormal,FloatBorder:FloatBorder",
			},
		},
		chat_window = {
			border = {
				style = "single",
			},
			win_options = {
				winhighlight = "Normal:FloatNormal,FloatBorder:FloatBorder",
			},
		},
		chat_input = {
			border = {
				style = "single",
			},
			win_options = {
				winhighlight = "Normal:FloatNormal,FloatBorder:FloatBorder",
			},
		},
	})

	local c = hls.colors()
	hls.register_hls({
		ChatGPTQuestion = { bold = true, italic = true },
		ChatGPTTotalTokens = { fg = c.bg, bg = c.white, italic = true },
		ChatGPTTotalTokensBorder = { fg = c.white, bg = c.white },
	})
end

return M
