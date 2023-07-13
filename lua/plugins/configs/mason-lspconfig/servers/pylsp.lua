local settings = {
	pylsp = {
		plugins = {
			jedi_completion = {
				enabled = true,
				cache_for = { "pandas", "numpy", "torch", "tensorflow", "matplotlib" },
				include_params = true,
				include_class_objects = true,
				include_function_objects = true,
				fuzzy = true,
				eager = false,
				resolve_at_most = 25,
			},
			jedi_hover = {
				enabled = true, -- pyright hover is better
			},
			jedi_definition = {
				enabled = true, -- faster than pyright, but can't disable pyright
				follow_imports = true,
				follow_builtin_imports = true,
				follow_builtin_definitions = true,
			},
			jedi_references = {
				enabled = true,
			},
			jedi_signature_help = {
				enabled = true,
			},
			jedi_symbols = {
				enabled = true,
				all_scopes = true,
				include_import_symbols = true,
			},
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
			mccabe = {
				enabled = true,
				threshold = 15,
			},
			rope_autoimport = {
				enabled = false,
				memory = true, -- drastically improves startup time
			},
		},
	},
}

return settings
