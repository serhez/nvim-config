require("refactoring").setup({
	-- Prompt for unguessable return types
	prompt_func_return_type = {
		go = true,
		java = true,
		cpp = true,
		c = true,
		h = true,
		hpp = true,
		cxx = true,
	},

	-- Prompt for unguessable function parameters
	prompt_func_param_type = {
		go = true,
		java = true,
		cpp = true,
		c = true,
		h = true,
		hpp = true,
		cxx = true,
	},
})

-- Telescope refactoring helper
require("telescope").load_extension("refactoring")
