local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	lazy = false,
}

local function custom_attach(_, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Fucking annoying as hell, buggy as fuck
	-- if client.server_capabilities.inlayHintProvider then
	-- 	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	-- end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

function M.config()
	local lspconfig = require("lspconfig")
	local mason_lspconfig = require("mason-lspconfig")

	mason_lspconfig.setup({
		automatic_enable = true,
	})

	local custom_capabilities = vim.lsp.protocol.make_client_capabilities()
	-- custom_capabilities.offsetEncoding = "utf-8"
	custom_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
	custom_capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
	custom_capabilities.textDocument.completion.completionItem.snippetSupport = true
	custom_capabilities.textDocument.completion.completionItem.preselectSupport = true
	custom_capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	custom_capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	custom_capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	custom_capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	custom_capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	custom_capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	-- passing config.capabilities to blink.cmp merges with the capabilities in your
	-- `opts[server].capabilities, if you've defined it
	local present, blink = pcall(require, "blink.cmp")
	if present then
		custom_capabilities = blink.get_lsp_capabilities(custom_capabilities)
	end

	for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
		local opts = {
			on_attach = custom_attach,
			capabilities = custom_capabilities,
			flags = {
				debounce_text_changes = 150,
			},
		}

		local has_custom_opts, custom_opts = pcall(require, "plugins.configs.mason-lspconfig.servers." .. server)
		if has_custom_opts then
			-- Enhance the default opts with the server-specific ones
			opts.settings = custom_opts
		end

		vim.lsp.config(server, opts)
	end

	-- Configure Dart/Flutter server here since it is not installed via Mason
	lspconfig.dartls.setup({
		cmd = { "dart", "language-server", "--protocol=lsp" },
		filetypes = { "dart" },
		init_options = {
			closingLabels = true,
			flutterOutline = true,
			onlyAnalyzeProjectsWithOpenFiles = true,
			outline = true,
			suggestFromUnimportedLibraries = true,
		},
		-- root_dir = root_pattern("pubspec.yaml"),
		settings = {
			dart = {
				completeFunctionCalls = true,
				showTodos = true,
			},
		},
		on_attach = custom_attach,
	})

	-- Configure Swift server here since it is not installed via Mason
	local sourcekit_opts = {
		on_attach = custom_attach,
		capabilities = vim.tbl_deep_extend("force", custom_capabilities, {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		}),
		flags = {
			debounce_text_changes = 150,
		},
	}
	local has_custom_opts, custom_opts = pcall(require, "plugins.configs.mason-lspconfig.servers.sourcekit")
	if has_custom_opts then
		sourcekit_opts.settings = custom_opts
	end
	lspconfig.sourcekit.setup(sourcekit_opts)
end

return M
