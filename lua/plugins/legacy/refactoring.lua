local M = {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
}

function M.config()
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
	local present, telescope = pcall(require, "telescope")
	if present then
		telescope.load_extension("refactoring")
	end
end

return M

