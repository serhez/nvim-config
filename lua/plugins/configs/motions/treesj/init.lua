local tsj = require("treesj")

tsj.setup({
	-- Use default keymaps
	-- (<space>m - toggle, <space>j - join, <space>s - split)
	use_default_keymaps = false,

	-- hold|start|end:
	-- hold - cursor follows the node/place on which it was called
	-- start - cursor jumps to the first symbol of the node being formatted
	-- end - cursor jumps to the last symbol of the node being formatted
	cursor_behavior = "hold",

	-- Notify about possible problems or not
	notify = false,
})
