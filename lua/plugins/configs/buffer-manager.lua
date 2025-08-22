local M = {
	"j-morano/buffer_manager.nvim",
	dev = true,
	name = "buffer_manager.nvim",
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
}

function M.init()
	require("mappings").register({
		{
			"<leader>;",
			function()
				require("buffer_manager.ui").toggle_persistent_menu()
			end,
			desc = "Buffer manager",
		},
	})
end

function M.config()
	require("buffer_manager").setup({
		select_menu_item_commands = {
			{
				key = "<CR>",
				command = "edit",
			},
			{
				key = ";",
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
