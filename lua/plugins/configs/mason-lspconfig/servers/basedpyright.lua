local settings = {
	basedpyright = {
		disableLanguageServices = false,
		disableOrganizeImports = true, -- performed by ruff
		disableTaggedHints = false,
		reportMissingSuperCall = false,
		analysis = {
			autoImportCompletions = true,
			autoSearchPaths = true,
			diagnosticMode = "openFilesOnly", -- "openFilesOnly" or "workspace"
			typeCheckingMode = "basic", -- "off", "basic", "standard", "strict" or "all"
			useLibraryCodeForTypes = true,
		},
	},

	python = {
		venvPath = "~/envs/",
	},
}

return settings
