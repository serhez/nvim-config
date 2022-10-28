require("null-ls").setup({
	sources = {
		-- Shell
		require("null-ls").builtins.diagnostics.shellcheck,
		require("null-ls").builtins.formatting.shfmt,

		-- Lua
		require("null-ls").builtins.formatting.stylua,

		-- Python
		-- require("null-ls").builtins.diagnostics.pylint, -- Too much noise!
		-- require("null-ls").builtins.diagnostics.pydocstyle, -- Too much noise!
		require("null-ls").builtins.formatting.isort,
		require("null-ls").builtins.formatting.black,

		-- C/C++
		require("null-ls").builtins.diagnostics.cppcheck,
		require("null-ls").builtins.formatting.clang_format,

		-- Golang
		require("null-ls").builtins.diagnostics.golangci_lint,
		require("null-ls").builtins.formatting.goimports,

		-- Javascript/Typescript; use Volar for Vue
		require("null-ls").builtins.code_actions.eslint_d.with({
			disabled_filetypes = { "vue" },
		}),
		require("null-ls").builtins.diagnostics.eslint_d.with({
			disabled_filetypes = { "vue" },
		}),
		require("null-ls").builtins.formatting.prettierd, -- Also Markdown, JSON, YAML, CSS, HTML, etc.

		-- Markdown
		-- formatting: prettierd
		-- require("null-ls").builtins.diagnostics.markdownlint, -- Too much noise!

		-- JSON
		-- formatting: prettierd
		require("null-ls").builtins.diagnostics.jsonlint,

		-- YAML
		-- formatting: prettierd
		require("null-ls").builtins.diagnostics.yamllint,

		-- TOML
		require("null-ls").builtins.formatting.taplo,

		-- Make/CMake
		require("null-ls").builtins.formatting.cmake_format,

		-- SQL
		require("null-ls").builtins.diagnostics.sqlfluff,
		require("null-ls").builtins.formatting.sqlfluff,
	},
})
