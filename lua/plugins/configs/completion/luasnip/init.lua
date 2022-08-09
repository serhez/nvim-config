local present, luasnip = pcall(require, "luasnip")
if present then
	local default = {
		history = true,
		updateevents = "TextChanged,TextChangedI",
	}
	luasnip.config.set_config(default)
	require("luasnip/loaders/from_vscode").load()
end
