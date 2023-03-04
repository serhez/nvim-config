local mappings = require("mappings")
local icons = require("icons")

local M = {
	"simrat39/symbols-outline.nvim",
	cmd = "SymbolsOutline",
}

function M.init()
	mappings.register_normal({
		c = {
			o = { "<cmd>SymbolsOutline<cr>", "Outline" },
		},
	})
end

function M.config()
	require("symbols-outline").setup({
		show_guides = false,
		auto_preview = false,
		width = 25,
		auto_close = true,
		preview_bg_highlight = "Pmenu",
		auto_unfold_hover = true,
		fold_markers = { icons.arrow.right_short, icons.arrow.down_short },
		wrap = false,
		keymaps = { -- These keymaps can be a string or a table for multiple keys
			close = { "<Esc>", "q" },
			goto_location = "<Cr>",
			focus_location = "o",
			hover_symbol = "<C-space>",
			toggle_preview = "K",
			rename_symbol = "r",
			code_actions = "a",
			fold = "h",
			unfold = "l",
			fold_all = "W",
			unfold_all = "E",
			fold_reset = "R",
		},
		lsp_blacklist = {},
		symbol_blacklist = {
			"Variable",
			"String",
			"Number",
			"Boolean",
			"Array",
			"Object",
			"Key",
			"Null",
		},
		symbols = {
			File = { icon = icons.lsp.File, hl = "@text.uri" },
			Module = { icon = icons.lsp.Module, hl = "@namespace" },
			Namespace = { icon = icons.lsp.Namespace, hl = "@namespace" },
			Package = { icon = icons.lsp.Package, hl = "@namespace" },
			Class = { icon = icons.lsp.Class, hl = "@type" },
			Method = { icon = icons.lsp.Method, hl = "@method" },
			Property = { icon = icons.lsp.Property, hl = "@method" },
			Field = { icon = icons.lsp.Field, hl = "@field" },
			Constructor = { icon = icons.lsp.Constructor, hl = "@constructor" },
			Enum = { icon = icons.lsp.Enum, hl = "@type" },
			Interface = { icon = icons.lsp.Interface, hl = "@type" },
			Function = { icon = icons.lsp.Function, hl = "@function" },
			Variable = { icon = icons.lsp.Variable, hl = "@constant" },
			Constant = { icon = icons.lsp.Constant, hl = "@constant" },
			String = { icon = icons.lsp.String, hl = "@string" },
			Number = { icon = icons.lsp.Number, hl = "@number" },
			Boolean = { icon = icons.lsp.Boolean, hl = "@boolean" },
			Array = { icon = icons.lsp.Array, hl = "@constant" },
			Object = { icon = icons.lsp.Object, hl = "@type" },
			Key = { icon = icons.lsp.Keyword, hl = "@type" },
			Null = { icon = icons.lsp.Null, hl = "@type" },
			EnumMember = { icon = icons.lsp.EnumMember, hl = "@field" },
			Struct = { icon = icons.lsp.Struct, hl = "@type" },
			Event = { icon = icons.lsp.Event, hl = "@type" },
			Operator = { icon = icons.lsp.Operator, hl = "@operator" },
			TypeParameter = { icon = icons.lsp.TypeParameter, hl = "@parameter" },
			Component = { icon = icons.lsp.Component, hl = "@function" },
			Fragment = { icon = icons.lsp.Fragment, hl = "@constant" },
		},
	})
end

return M
