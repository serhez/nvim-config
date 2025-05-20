local settings = {
	RoslynExtensionsOptions = {
		InlayHintsOptions = {
			EnableForParameters = true,
			ForLiteralParameters = true,
			ForIndexerParameters = true,
			ForObjectCreationParameters = true,
			ForOtherParameters = true,
			SuppressForParametersThatDifferOnlyBySuffix = false,
			SuppressForParametersThatMatchMethodIntent = false,
			SuppressForParametersThatMatchArgumentName = false,
			EnableForTypes = true,
			ForImplicitVariableTypes = true,
			ForLambdaParameterTypes = true,
			ForImplicitObjectCreatio = true,
		},
	},
}

return settings
