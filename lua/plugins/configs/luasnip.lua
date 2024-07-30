local M = {
	"L3MON4D3/LuaSnip",
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
}

function M.config()
	require("luasnip").config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	require("luasnip/loaders/from_vscode").lazy_load()
end

return M
