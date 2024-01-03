local M = {
	"kawre/neotab.nvim",
	event = "InsertEnter",
	enabled = false,
}

function M.config()
	require("neotab").setup({
		tabkey = "", -- NOTE: set by cmp and luasnip
		act_as_tab = true, -- fallback to tab, if `tabout` action is not available
		smart_punctuators = {
			enabled = true,
			semicolon = {
				enabled = true,
				ft = {
					"cs",
					"c",
					"cpp",
					"java",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"tsx",
					"jsx",
					"rescript",
				},
			},
			escape = {
				enabled = true,
			},
		},
	})
end

return M
