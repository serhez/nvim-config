require("mason").setup({
	ui = {
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "single",
	},

	-- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
	-- packages that are requested to be installed will be put in a queue.
	max_concurrent_installers = 4,
})
