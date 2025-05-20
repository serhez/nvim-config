local settings = {
	clangd = {
		InlayHints = {
			Designators = true,
			Enabled = true,
			ParameterNames = true,
			DeducedTypes = true,
		},
		fallbackFlags = { "-std=c++20" },
	},
}

return settings
