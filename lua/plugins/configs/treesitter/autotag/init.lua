-- FIX: Not working on filetypes htmldjango
require("nvim-ts-autotag").setup({
	filetypes = { "html", "xml", "htmldjango", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue" },
	skip_tags = {},
})
