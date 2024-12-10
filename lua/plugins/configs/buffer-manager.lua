local M = {
	"j-morano/buffer_manager.nvim",
	dev = true,
	name = "buffer_manager.nvim",
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	require("mappings").register({
		{
			"<TAB>",
			function()
				require("buffer_manager.ui").toggle_quick_menu()
			end,
			desc = "Buffers",
		},
	})
end

function M.config()
	require("buffer_manager").setup({
		line_keys = {
			"s",
			"f",
			"g",
			"z",
			"n",
			"m",
			"t",
			"1",
			"2",
			"3",
			"4",
			"5",
			"6",
			"7",
			"8",
			"9",
			"0",
		},
		select_menu_item_commands = {
			{
				key = "<CR>",
				command = "edit",
			},
			{
				key = "<TAB>",
				command = "edit",
			},
		},
		focus_alternate_buffer = true,
		short_file_names = true,
		short_term_names = true,
		order_buffers = "lastused",
		show_indicators = "after",
	})
end

return M
