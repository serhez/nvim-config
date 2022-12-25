local M = {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
}

function M.config()
	local default = {
		history = true,
		updateevents = "TextChanged,TextChangedI",
	}
	require("luasnip").config.set_config(default)
	require("luasnip/loaders/from_vscode").load()
end

return M
