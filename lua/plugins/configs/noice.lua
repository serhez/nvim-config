local M = {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"Bekaboo/dropbar.nvim",
	},
	-- commit = "69c6ad5c1f1c0777125d0275f9871d8609cb0521",
	lazy = false,
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register({ "<leader>un", "<cmd>Noice<cr>", desc = "Notifications" })
end

function M.config()
	local hls = require("highlights")
	local icons = require("icons")

	require("noice").setup({
		health = {
			checker = false, -- Disable if you don't want health checks to run
		},

		cmdline = {
			view = "cmdline",
			format = {
				cmdline = { icon = " " .. icons.arrow.right_short_thick },
				search_down = { icon = " " .. icons.lupa .. " " .. icons.arrow.double_down_short },
				search_up = { icon = " " .. icons.lupa .. " " .. icons.arrow.double_up_short },
				filter = { icon = " " .. icons.filter },
				lua = { icon = " " .. icons.language.lua },
				help = { icon = " " .. icons.question },
			},
		},

		views = {
			hover = {
				border = {
					-- `"double"`, `"none"`, `"rounded"`, `"shadow"`, `"single"` or `"solid"`
					style = "single",
					padding = { 0, 0 },
				},
				position = { row = 0, col = 0 },
			},
			mini = {
				timeout = 4000, -- Duration between show() and hide(), in milliseconds
				win_options = {
					winblend = 0,
				},
				winhighlight = {},
			},
		},

		notify = {
			enabled = true,
			view = "mini",
		},

		messages = {
			enabled = true, -- enables the Noice messages UI
			view = false, -- default view for messages
			view_error = "mini", -- view for errors
			view_warn = "mini", -- view for warnings
			view_history = "messages", -- view for :messages
			view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
		},

		lsp = {
			override = {
				-- override the default lsp markdown formatter with Noice
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				-- override the lsp markdown formatter with Noice
				["vim.lsp.util.stylize_markdown"] = true,
				-- override cmp documentation with Noice (needs the other options to work)
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
			message = {
				enabled = true,
				view = "mini",
			},
			hover = {
				enabled = true,
				silent = true,
			},
			signature = {
				enabled = false,
			},
			-- defaults for hover and signature help
			documentation = {
				view = "hover",
				opts = {
					lang = "markdown",
					replace = true,
					render = "plain",
					format = { "{message}" },
					win_options = {
						concealcursor = "n",
						conceallevel = 3,
					},
				},
			},
		},

		routes = {
			{
				view = "confirm",
				filter = {
					any = {
						{ event = "msg_show", kind = "confirm" },
						{ event = "msg_show", kind = { "echo", "echomsg", "" }, before = true },
						{ event = "msg_show", kind = { "echo", "echomsg" }, instant = true },
					},
				},
			},
			{
				view = "cmdline",
				filter = {
					any = {
						{ event = "msg_show", kind = "confirm_sub" },
					},
				},
			},

			-- Send long messages to a split window
			{
				view = "split",
				filter = { event = "msg_show", min_height = 5 },
			},
		},
	})

	-- So that we can use markdown rendering plugins on the hover and signature windows
	vim.treesitter.language.register("markdown", "noice")

	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		NoiceCmdline = { fg = c.statusline_fg, bg = c.statusline_bg, blend = 0 },
		NoiceCmdlinePopupBorder = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderCmdline = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderFilter = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderHelp = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderIncRename = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderInput = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderLua = common_hls.no_border_statusline,
		NoiceCmdlinePopupBorderSearch = common_hls.no_border_statusline,
		NoiceConfirm = { default = true, bg = c.statusline_bg },
		NoiceConfirmBorder = common_hls.no_border_statusline,
		NoicePopupBorder = common_hls.no_border_statusline,
		NoicePopupmenuBorder = common_hls.no_border_statusline,
		NoiceSplitBorder = common_hls.no_border_statusline,
	})
end

return M
