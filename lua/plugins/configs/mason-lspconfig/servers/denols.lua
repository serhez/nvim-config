local settings = {
	deno = {
		inlayHints = {
			parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
			parameterTypes = { enabled = true },
			variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enable = true },
			enumMemberValues = { enabled = true },
		},
	},
}

return settings
