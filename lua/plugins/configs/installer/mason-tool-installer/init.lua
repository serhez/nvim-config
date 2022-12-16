-- BUG: This plugin is not running concurrently and creates a lot of lag on nvim's init
--      We need to find a way to make this run async (already asked the plugin's author, but maybe I can manage this myself)

require("mason-tool-installer").setup({
	-- A list of all tools you want to ensure are installed upon
	-- start; they should be the names Mason uses for each tool
	ensure_installed = {
		-- Assembly
		"asm-lsp",

		-- Shell/Bash
		"bash-language-server",
		"shellcheck",
		"shfmt",

		-- Python
		"pyright",
		"pylint",
		"pydocstyle",
		"black",
		"isort",
		"debugpy",

		-- C/C++
		"clangd",
		"clang-format",

		-- R
		"r-languageserver",

		-- Rust
		"rust-analyzer",

		-- Go
		"gopls",
		"golangci-lint",
		"goimports",
		"delve",

		-- Lua
		"lua-language-server",
		"vim-language-server",
		"stylua",

		-- JavaScript/TypeScript
		"typescript-language-server",
		"svelte-language-server",
		"vue-language-server",
		"eslint_d",
		"prettierd",

		-- HTML
		"html-lsp",

		-- CSS
		"css-lsp",
		"tailwindcss-language-server",

		-- JSON
		"json-lsp",

		-- YAML
		"yaml-language-server",
		"yamllint",

		-- XML
		"lemminx",

		-- TOML
		"taplo",

		-- Make/CMake
		"cmake-language-server",

		-- Dockerfile
		"dockerfile-language-server",

		-- SQL
		"sqls",
		"sqlfluff",

		-- Markdown
		"markdownlint",

		-- LaTeX
		"texlab",
	},

	-- If set to true this will check each tool for updates. If updates
	-- are available the tool will be updated.
	-- Default: false
	auto_update = true,

	-- Automatically install / update on startup. If set to false nothing
	-- will happen on startup. You can use `:MasonToolsUpdate` to install
	-- tools and check for updates.
	-- Default: true
	-- BUG: It degrades performance greatly on startup for a few seconds
	--      https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/20
	run_on_start = false,

	-- Set a delay (in ms) before the installation starts. This is only
	-- effective if run_on_start is set to true.
	-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
	-- Default: 0
	start_delay = 0,
})
