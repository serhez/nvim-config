local M = {
	"serhez/teide.nvim",
	dev = true,
	name = "teide.nvim",
}

function M.config()
	local teide = require("teide")
	teide.setup({
		terminal_colors = true,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},

			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "dark",
			floats = "dark",
		},
		sidebars = {
			"qf",
			"help",
			"dapui_scopes",
			"dapui_watches",
			"dapui_stacks",
			"dapui_breakpoints",
			"dapui_console",
			"dap-repl",
		},
		plugins = {
			auto = true,
		},
		dim_inactive = false,
	})
	teide.load()
end

return M
