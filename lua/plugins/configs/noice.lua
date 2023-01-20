local hls = require("highlights")

local M = {
	"folke/noice.nvim",
	dependencies = {
		-- If you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- `nvim-notify` is only needed, if you want to use the notification view.
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
}

function M.config()
	require("noice").setup({
		health = {
			checker = false, -- Disable if you don't want health checks to run
		},

		cmdline = {
			view = "cmdline",
		},

		override = {
			-- override the default lsp markdown formatter with Noice
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			-- override the lsp markdown formatter with Noice
			["vim.lsp.util.stylize_markdown"] = true,
			-- override cmp documentation with Noice (needs the other options to work)
			["cmp.entry.get_documentation"] = true,
		},

		views = {
			hover = {
				border = {
					style = "single",
				},
				position = { row = 2, col = 2 },
			},
		},

		notify = {
			enabled = true,
			view = "mini",
		},

		messages = {
			enabled = true, -- enables the Noice messages UI
			view = "mini", -- default view for messages
			view_error = "notify", -- view for errors
			view_warn = "notify", -- view for warnings
			view_history = "messages", -- view for :messages
			view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
		},

		lsp = {
			message = {
				enabled = true,
				view = "mini",
			},
		},
	})

	require("telescope").load_extension("noice")

	local common_hls = hls.common_hls()
	hls.register_hls({
		NoiceCmdlinePopupBorder = common_hls.border,
		NoiceCmdlinePopupBorderCmdline = common_hls.border,
		NoiceCmdlinePopupBorderFilter = common_hls.border,
		NoiceCmdlinePopupBorderHelp = common_hls.border,
		NoiceCmdlinePopupBorderIncRename = common_hls.border,
		NoiceCmdlinePopupBorderInput = common_hls.border,
		NoiceCmdlinePopupBorderLua = common_hls.border,
		NoiceCmdlinePopupBorderSearch = common_hls.border,
		NoiceConfirmBorder = common_hls.border,
		NoicePopupBorder = common_hls.border,
		NoicePopupmenuBorder = common_hls.border,
		NoiceSplitBorder = common_hls.border,
	})
end

return M
