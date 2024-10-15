local M = {
	"hedyhli/outline.nvim",
	cmd = "Outline",
}

function M.init()
	require("mappings").register({ "<leader>o", "<cmd>Outline<cr>", desc = "Outline" })
end

function M.config()
	local icons = require("icons")
	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		OutlineWindow = { fg = c.statusline_fg, bg = c.statusline_bg },
		OutlinePreviewWindow = { fg = c.statusline_fg, bg = c.statusline_bg },
	})

	require("outline").setup({
		outline_window = {
			winhl = "Normal:OutlineWindow",
			wrap = false,
			-- hide_cursor = true, -- BUG: not working
		},
		symbol_folding = {
			-- Depth past which nodes will be folded by default. Set to false to unfold all on open.
			autofold_depth = false,
			-- When to auto unfold nodes
			auto_unfold = {
				-- Auto unfold currently hovered symbol
				hovered = true,
				-- Auto fold when the root level only has this many nodes.
				-- Set true for 1 node, false for 0.
				only = true,
			},
		},
		preview_window = {
			border = "solid",
			winblend = 10,
			winhl = "Normal:OutlinePreviewWindow",
		},
		guides = {
			enabled = true,
			markers = {
				bottom = icons.bar.vertical_center_thin,
				middle = icons.bar.vertical_center_thin,
				vertical = icons.bar.vertical_center_thin,
			},
		},
		providers = {
			markdown = {
				-- List of supported ft's to use the markdown provider
				filetypes = { "markdown", "quarto", "rmd" },
			},
		},
		keymaps = {
			show_help = "?",
			close = { "<Esc>", "q" },
			-- Jump to symbol under cursor.
			-- It can auto close the outline window when triggered, see
			-- 'auto_close' option above.
			goto_location = "<Cr>",
			-- Jump to symbol under cursor but keep focus on outline window.
			peek_location = "o",
			-- Visit location in code and close outline immediately
			goto_and_close = "<S-Cr>",
			-- Change cursor position of outline window to match current location in code.
			-- 'Opposite' of goto/peek_location.
			restore_location = "<C-g>",
			-- Open LSP/provider-dependent symbol hover information
			hover_symbol = "<C-k>",
			-- Preview location code of the symbol under cursor
			toggle_preview = "K",
			rename_symbol = "r",
			code_actions = "a",
			-- These fold actions are collapsing tree nodes, not code folding
			fold = {},
			unfold = {},
			fold_toggle = { "h", "l" },
			-- Toggle folds for all nodes.
			-- If at least one node is folded, this action will fold all nodes.
			-- If all nodes are folded, this action will unfold all nodes.
			fold_toggle_all = "z",
			-- fold_all = "W",
			-- unfold_all = "E",
			-- fold_reset = "R",
			-- Move down/up by one line and peek_location immediately.
			-- You can also use outline_window.auto_jump=true to do this for any
			-- j/k/<down>/<up>.
			down_and_jump = "<C-j>",
			up_and_jump = "<C-k>",
		},
		symbols = {
			filter = {
				default = { "String", exclude = true },
				python = { "String", "Variable", exclude = true },
			},
			icons = {
				File = { icon = icons.lsp.File, hl = "Identifier" },
				Module = { icon = icons.lsp.Module, hl = "Include" },
				Namespace = { icon = icons.lsp.Namespace, hl = "Include" },
				Package = { icon = icons.lsp.Package, hl = "Include" },
				Class = { icon = icons.lsp.Class, hl = "Type" },
				Method = { icon = icons.lsp.Method, hl = "Function" },
				Property = { icon = icons.lsp.Property, hl = "Identifier" },
				Field = { icon = icons.lsp.Field, hl = "Identifier" },
				Constructor = { icon = icons.lsp.Constructor, hl = "Special" },
				Enum = { icon = icons.lsp.Enum, hl = "Type" },
				Interface = { icon = icons.lsp.Interface, hl = "Type" },
				Function = { icon = icons.lsp.Function, hl = "Function" },
				Variable = { icon = icons.lsp.Variable, hl = "Constant" },
				Constant = { icon = icons.lsp.Constant, hl = "Constant" },
				String = { icon = icons.lsp.String, hl = "String" },
				Number = { icon = icons.lsp.Number, hl = "Number" },
				Boolean = { icon = icons.lsp.Boolean, hl = "Boolean" },
				Array = { icon = icons.lsp.Array, hl = "Constant" },
				Object = { icon = icons.lsp.Object, hl = "Type" },
				Key = { icon = icons.lsp.Keyword, hl = "Type" },
				Null = { icon = icons.lsp.Null, hl = "Type" },
				EnumMember = { icon = icons.lsp.EnumMember, hl = "Identifier" },
				Struct = { icon = icons.lsp.Struct, hl = "Structure" },
				Event = { icon = icons.lsp.Event, hl = "Type" },
				Operator = { icon = icons.lsp.Operator, hl = "Identifier" },
				TypeParameter = { icon = icons.lsp.TypeParameter, hl = "Identifier" },
				Component = { icon = icons.lsp.Component, hl = "Function" },
				Fragment = { icon = icons.lsp.Fragment, hl = "Constant" },
				TypeAlias = { icon = icons.lsp.TypeParameter, hl = "Type" },
				Parameter = { icon = icons.lsp.Field, hl = "Identifier" },
				StaticMethod = { icon = icons.lsp.Method, hl = "Function" },
				Macro = { icon = icons.lsp.Text, hl = "Function" },
			},
		},
	})
end

return M
