local icons = require("icons")

require("incline").setup({
	render = function()
		local name, icon = require("feline").providers.file_info({}, {
			type = "base-only",
			file_readonly_icon = icons.lock .. icons.single_space,
		})

		return string.format("%s%s", icon.str, name)
	end,
	window = {
		margin = {
			horizontal = 0,
			vertical = 0,
		},
	},
})
