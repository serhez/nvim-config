local settings = {
	gopls = {
		hints = {
			rangeVariableTypes = true,
			parameterNames = true,
			constantValues = true,
			assignVariableTypes = true,
			compositeLiteralFields = true,
			compositeLiteralTypes = true,
			functionTypeParameters = true,
		},
	},
}

return settings
