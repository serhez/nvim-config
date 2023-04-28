local settings = {
	pylsp = {
		plugins = {
			pycodestyle = {
				ignore = { "E501", "W292", "W503" },
				maxLineLength = 100,
			},
			autopep8 = {
				enabled = false,
			},
			pydocstyle = {
				enabled = false,
			},
			jedi_hover = {
				enabled = false, -- pyright hover is better
			},
		},
	},
}

return settings
