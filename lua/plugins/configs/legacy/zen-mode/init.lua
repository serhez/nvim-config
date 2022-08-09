require("zen-mode").setup({
	window = {
		backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
		-- height and width can be:
		-- * an absolute number of cells when > 1
		-- * a percentage of the width / height of the editor when <= 1
		width = 120, -- width of the Zen window
		height = 0.8, -- height of the Zen window
		-- by default, no options are changed for the Zen window
		-- uncomment any of the options below, or add other vim.wo options you want to apply
		options = {
			signcolumn = "no", -- disable signcolumn
			number = false, -- disable number column
			relativenumber = false, -- disable relative numbers
			-- cursorline = false, -- disable cursorline
			-- cursorcolumn = false, -- disable cursor column
			-- foldcolumn = "0", -- disable fold column
			-- list = false, -- disable whitespace characters
		},
	},
	plugins = {
		gitsigns = true, -- disables git signs
		tmux = true, -- disables the tmux statusline
		-- this will change the font size on kitty when in Zen mode
		-- to make this work, you need to set the following kitty options:
		-- - allow_remote_control socket-only
		-- - listen_on unix:/tmp/kitty
		-- kitty = {
		--     enabled = false,
		--     font = "+4", -- font size increment
		-- },
	},
	-- callback where you can add custom code when the Zen window opens
	-- on_open = function(win)
	-- end,
	-- callback where you can add custom code when the Zen window closes
	-- on_close = function()
	-- end,
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
})
