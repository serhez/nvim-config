local settings = {
	pyright = {
		autoImportCompletion = true,
	},
	python = {
		analysis = {
			autoSearchPaths = true,
			diagnosticMode = "openFileOnly", -- instead of "workspace"
			useLibraryCodeForTypes = true, -- could be set to false to be faster
			-- typeCheckingMode = "off",
		},
	},
}

return settings
