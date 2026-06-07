-- Path to the Mason-installed Vue language server, which bundles
-- `@vue/typescript-plugin`. vtsls loads this plugin so it can provide
-- TypeScript support inside `.vue` SFCs -- required by `vue_ls`, which runs in
-- "hybrid mode" and forwards TS requests to a sibling vtsls/ts_ls client.
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local settings = {
	-- Extend vtsls beyond its default JS/TS filetypes so it also attaches to
	-- `.vue` buffers; without this, `vue_ls` can't find a TS client and errors.
	-- (Lifted to the top-level `filetypes` opt by mason-lspconfig/init.lua.)
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	vtsls = {
		tsserver = {
			globalPlugins = {
				{
					name = "@vue/typescript-plugin",
					location = vue_language_server_path,
					languages = { "vue" },
					configNamespace = "typescript",
				},
			},
		},
	},
	typescript = {
		inlayHints = {
			parameterNames = { enabled = "all" },
			parameterTypes = { enabled = true },
			variableTypes = { enabled = true },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = true },
			enumMemberValues = { enabled = true },
		},
	},
}

return settings
