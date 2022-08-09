require("mason-tool-installer").setup({
	-- a list of all tools you want to ensure are installed upon
	-- start; they should be the names Mason uses for each tool
	ensure_installed = {
		"bash-language-server",
		"black",
		"clangd",
		"clang-format",
		"cmake-language-server",
		"css-lsp",
		"debugpy",
		"delve",
		"dockerfile-language-server",
		"eslint-lsp",
		"eslint_d",
		"goimports",
		"golangci-lint",
		"gopls",
		"html-lsp",
		"isort",
		"json-lsp",
		"lemminx",
		"lua-language-server",
		"markdownlint",
		"prettierd",
		"pylint",
		"pyright",
		"shellcheck",
		"sqls",
		"stylua",
		"svelte-language-server",
		"rust-analyzer",
		"tailwindcss-language-server",
		"texlab",
		"vim-language-server",
		"vue-language-server",
		"yamllint",
		"yaml-language-server",
	},

	-- if set to true this will check each tool for updates. If updates
	-- are available the tool will be updated.
	-- Default: false
	auto_update = true,

	-- automatically install / update on startup. If set to false nothing
	-- will happen on startup. You can use `:MasonToolsUpdate` to install
	-- tools and check for updates.
	-- Default: true
	run_on_start = true,

	-- set a delay (in ms) before the installation starts. This is only
	-- effective if run_on_start is set to true.
	-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
	-- Default: 0
	start_delay = 5000, -- 5 seconds delay
})
