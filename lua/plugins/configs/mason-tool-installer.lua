-- BUG: This plugin is not running concurrently and creates a lot of lag on nvim's init
--      We need to find a way to make this run async (already asked the plugin's author, but maybe I can manage this myself)

local M = {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	cmd = {
		"MasonToolsClean",
		"MasonToolsInstall",
		"MasonToolsInstallSync",
		"MasonToolsUpdate",
		"MasonToolsUpdateSync",
	},
}

function M.init()
	require("mappings").register({ "<leader>ii", "<cmd>MasonToolsInstall<cr>", desc = "Install missing tools" })
end

function M.config()
	require("mason-tool-installer").setup({
		-- A list of all tools you want to ensure are installed upon
		-- start; they should be the names Mason uses for each tool
		ensure_installed = {
			-- Text (general: grammar, syntax, etc.)
			-- "harper_ls",  -- annoying
			"grammarly-languageserver",

			-- Security
			"snyk",
			"trivy",
			"gitleaks",

			-- Assembly
			"asm-lsp",

			-- Shell/Bash
			"bash-language-server",
			"shellcheck",
			"shfmt",

			-- Python
			-- "python-lsp-server",
			-- "pyright",
			"basedpyright",
			"pylint",
			"pydocstyle",
			"ruff",
			"debugpy",

			-- C/C++
			"clangd",
			"clang-format",

			-- R
			"r-languageserver",

			-- Julia
			"julia-lsp",

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
			-- "typescript-language-server", -- replaced by vtsls
			"vtsls",
			"svelte-language-server",
			"vue-language-server",
			"eslint_d",
			"prettierd",

			-- Swift
			-- "sourcekit-lsp", -- not available on mason, make sure to install manually
			"swiftlint",

			-- Dart/Flutter
			"dart-debug-adapter",
			"dcm",
			"dart-lsp",
			"dartfmt",
			"flutter",

			-- HTML
			"html-lsp",

			-- CSS
			"css-lsp",
			"cssmodules-language-server",
			"css-variables-language-server",
			"tailwindcss-language-server",

			-- JSON
			"json-lsp",
			"jsonlint",
			"jq",

			-- YAML
			"yaml-language-server",
			"yamllint",
			-- "hydra-lsp", -- too slow

			-- XML
			"lemminx",

			-- TOML
			"taplo",

			-- Make/CMake
			"cmake-language-server",

			-- Dockerfile
			"dockerfile-language-server",

			-- SQL
			"sqlls",
			"sqlfluff",
			"sql-formatter",

			-- Markdown / LaTeX
			"markdownlint",
			"texlab",
			"latexindent",
			-- "vale",
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
end

return M
