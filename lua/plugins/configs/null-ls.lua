local M = {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "BufReadPre",
}

function M.config()
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			-- Shell
			null_ls.builtins.diagnostics.shellcheck,
			null_ls.builtins.formatting.shfmt,

			-- Lua
			null_ls.builtins.formatting.stylua,

			-- Python
			-- null_ls.builtins.diagnostics.pylint, -- Too much noise!
			-- null_ls.builtins.diagnostics.pydocstyle, -- Too much noise!
			null_ls.builtins.diagnostics.mypy,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.black,

			-- C/C++
			null_ls.builtins.diagnostics.cppcheck,
			null_ls.builtins.formatting.clang_format,

			-- Golang
			null_ls.builtins.diagnostics.golangci_lint,
			null_ls.builtins.formatting.goimports,

			-- Javascript/Typescript
			null_ls.builtins.code_actions.eslint_d.with({
				disabled_filetypes = { "vue" }, -- use Volar for Vue
			}),
			null_ls.builtins.diagnostics.eslint_d.with({
				disabled_filetypes = { "vue" }, -- use Volar for Vue
			}),
			null_ls.builtins.formatting.prettierd, -- Also Markdown, JSON, YAML, CSS, HTML, etc.

			-- Markdown
			-- formatting: prettierd
			-- null_ls.builtins.diagnostics.markdownlint, -- Too much noise!

			-- JSON
			-- formatting: prettierd
			null_ls.builtins.diagnostics.jsonlint,

			-- YAML
			-- formatting: prettierd
			null_ls.builtins.diagnostics.yamllint,

			-- TOML
			null_ls.builtins.formatting.taplo,

			-- Make/CMake
			null_ls.builtins.formatting.cmake_format,

			-- SQL
			null_ls.builtins.diagnostics.sqlfluff,
			null_ls.builtins.formatting.sqlfluff,
		},
	})
end

return M
