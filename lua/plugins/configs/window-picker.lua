local M = {
	"s1n7ax/nvim-window-picker",
}

function M.config()
	require("window-picker").setup({
		-- type of hints you want to get
		-- following types are supported
		-- 'statusline-winbar' | 'floating-big-letter'
		-- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
		-- 'floating-big-letter' draw big letter on a floating window
		-- used
		hint = "floating-big-letter",

		-- whether to show 'Pick window:' prompt
		show_prompt = true,

		-- prompt message to show to get the user input
		prompt_message = "Pick window: ",

		-- following filters are only applied when you are using the default filter
		-- defined by this plugin. If you pass in a function to "filter_func"
		-- property, you are on your own
		filter_rules = {
			-- when there is only one window available to pick from, use that window
			-- without prompting the user to select
			autoselect_one = true,

			-- whether you want to include the window you are currently on to window
			-- selection or not
			include_current_win = false,

			-- filter using buffer options
			bo = {
				-- if the file type is one of following, the window will be ignored
				filetype = { "NvimTree", "neo-tree", "notify", "noice", "NvimSeparator" },

				-- if the file type is one of following, the window will be ignored
				buftype = { "terminal" },
			},
		},
	})
end

return M
