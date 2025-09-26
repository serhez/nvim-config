local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	lazy = false,
}

local function custom_attach(_, bufnr)
	local ver = vim.version()

	if ver.major > 0 or ver.minor >= 12 then
		vim.lsp.on_type_formatting.enable(true)
		vim.lsp.inline_completion.enable(true)
	end

	vim.lsp.semantic_tokens.enable(true)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

function M.config()
	local ver = vim.version()
	local mason_lspconfig = require("mason-lspconfig")

	mason_lspconfig.setup({
		automatic_enable = true,
	})

	local custom_capabilities = vim.lsp.protocol.make_client_capabilities()

	-- passing config.capabilities to blink.cmp merges with the capabilities in your
	-- `opts[server].capabilities, if you've defined it
	local present, blink = pcall(require, "blink.cmp")
	if present then
		custom_capabilities = blink.get_lsp_capabilities(custom_capabilities)
	end

	-- custom_capabilities.offsetEncoding = "utf-8"
	custom_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
	custom_capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
	custom_capabilities.textDocument.completion.completionItem.snippetSupport = true
	custom_capabilities.textDocument.completion.completionItem.preselectSupport = true
	custom_capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	custom_capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	custom_capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	custom_capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	custom_capabilities.textDocument.completion.completionItem.tagSupport.valueSet = { 1 }
	custom_capabilities.textDocument.completion.completionItem.resolveSupport.properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	}
	custom_capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	if ver.major > 0 or ver.minor >= 12 then
		custom_capabilities.textDocument.onTypeFormatting.dynamicRegistration = false
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
			opts.settings = custom_opts
		end

		vim.lsp.config(server, opts)
	end

	-- Configure Dart/Flutter server here since it is not installed via Mason
	vim.lsp.config("dartls", {
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
		capabilities = custom_capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}
	local has_custom_opts, custom_opts = pcall(require, "plugins.configs.mason-lspconfig.servers.sourcekit")
	if has_custom_opts then
		sourcekit_opts.settings = custom_opts
	end
	vim.lsp.config("sourcekit", sourcekit_opts)

	-- Enable LSP codelens
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		callback = function()
			vim.lsp.codelens.refresh({ bufnr = 0 })
		end,
	})

	-- NOTE: handled by `coilot.lua` plugin
	-- Keymaps for inline ghost text completion (e.g., Copilot)
	vim.keymap.set("i", "<C-l>", function()
		if not vim.lsp.inline_completion.get() then
			return "<C-l>"
		end
	end, {
		expr = true,
		replace_keycodes = true,
		desc = "Accept inline completion",
	})
end

return M
