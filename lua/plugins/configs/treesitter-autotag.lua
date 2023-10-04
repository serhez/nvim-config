local M = {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	ft = {
		"html",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"tsx",
		"jsx",
		"rescript",
		"xml",
		"php",
		"markdown",
		"astro",
		"glimmer",
		"handlebars",
		"hbs",
	},
}

M.config = function()
	require("nvim-ts-autotag").setup()
end

return M
