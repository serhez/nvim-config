local M = {
	"luukvbaal/statuscol.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	lazy = false,
	cond = not vim.g.started_by_firenvim,
}

function M.config()
	local builtin = require("statuscol.builtin")
	local clickmod = "c"

	require("statuscol").setup({
		separator = "", -- separator between line number and buffer text ("│" or extra " " padding)
		thousands = false, -- false or line number thousands separator string ("." / ",")
		relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
		setopt = true, -- whether to set the 'statuscolumn', providing builtin click actions
		clickmod = clickmod, -- modifier used for certain actions: "a" for Alt, "c" for Ctrl and "m" for Meta
		segments = {
			{
				sign = {
					namespace = { "diagnostic.signs" },
					colwidth = 1,
					maxwidth = 1,
				},
				click = "v:lua.ScSa",
			},
			-- {
			-- 	sign = { name = { "todo*" }, colwidth = 1 },
			-- },
			-- {
			-- 	sign = {
			-- 		name = { ".*" },
			-- 		text = { ".*" },
			-- 		colwidth = 1, -- with `colwidth = 2`, we get a space between each sign, but the statusline is too wide
			-- 		maxwidth = 2,
			-- 	},
			-- 	click = "v:lua.ScSa",
			-- },
			{
				sign = {
					name = { "Dap*", "RecallSign" },
					colwidth = 1,
				},
			},
			{
				text = { builtin.lnumfunc, " " },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScLa",
			},
			{
				sign = { namespace = { "gitsigns" }, colwidth = 1, wrap = true },
				click = "v:lua.ScSa",
			},
			{
				text = { builtin.foldfunc, " " },
				sign = { maxwidth = 2, colwidth = 2 },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScFa",
			},
		},
		ft_ignore = {
			"neo-tree",
			"nvim-tree",
			"Outline",
			"Trouble",
			"lazy",
			"help",
			"spectre",
			"spectre_panel",
			"toggleterm",
			"dapui_scopes",
			"dapui_breakpoints",
			"dapui_stacks",
			"dapui_watches",
			"dapui_console",
			"dapui_repl",
			"dap-repl",
			"vuffers",
			"snacks_picker_input",
			"snacks_picker_preview",
		},
		bt_ignore = { "nofile", "terminal" },
	})

	-- Replace default DAP breakpoint function to use persistent breakpoints
	builtin.toggle_breakpoint = function(args)
		local present_pb, pb = pcall(require, "persistent-breakpoints.api")
		if present_pb then
			if args.mods:find(clickmod) then
				vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
					pb.set_conditional_breakpoint(input)
				end)
			else
				pb.toggle_breakpoint()
			end
			return
		end

		-- Fallback to default DAP breakpoint function
		local present_dap, dap = pcall(require, "dap")
		if not present_dap then
			return
		end
		if args.mods:find(clickmod) then
			vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
				dap.set_breakpoint(input)
			end)
		else
			dap.toggle_breakpoint()
		end
	end

	-- local ui = require("ui")
	-- ui.set_separators()
end

return M
