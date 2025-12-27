local M = {
	"serhez/teide.nvim",
	name = "teide.nvim",
}

function M.config()
	local tokyonight = require("tokyonight")
	tokyonight.setup({
		terminal_colors = true,
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "dark", -- style for sidebars, see below
			floats = "dark", -- style for floating windows
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
		-- on_highlights = function(hl, c)
		-- hl.CursorColumn = {
		-- 	bg = c.bg_dark,
		-- 	fg = c.fg_dark,
		-- }
		-- end,
	})
	tokyonight.load()
end

return M
