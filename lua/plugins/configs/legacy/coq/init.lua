vim.g.coq_settings = {
	auto_start = "shut-up",
	xdg = true,
	clients = {
		tabnine = { enabled = true },
	},
	display = {
		preview = {
			border = "single",
			positions = { north = 2, south = 3, west = 4, east = 1 },
		},
	},
	keymap = {
		bigger_preview = "<C-b>",
		jump_to_mark = "C-m",
	},
}
