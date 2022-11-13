require("noice").setup({
	health = {
		checker = false, -- Disable if you don't want health checks to run
	},

	cmdline = {
		view = "cmdline",
		-- FIX: IncRename works poorly due to the references window which is opened on top of the cmdline
		-- format = {
		-- 	IncRename = {
		-- 		pattern = "^:%s*IncRename%s+",
		-- 		icon = " ",
		-- 		conceal = true,
		-- 		opts = {
		-- 			relative = "cursor",
		-- 			size = { min_width = 20 },
		-- 			position = { row = -3, col = 0 },
		-- 		},
		-- 	},
		-- },
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

	-- Do not show normal messages
	routes = {
		{
			filter = {
				event = "msg_show",
			},
			opts = { skip = true },
		},
	},
})
