require("null-ls").setup({
	sources = {
		-- Shell
		require("null-ls").builtins.diagnostics.shellcheck,

		-- Lua
		require("null-ls").builtins.formatting.stylua,

		-- Python
		require("null-ls").builtins.diagnostics.pylint,
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
		require("null-ls").builtins.formatting.prettierd.with({ -- Also Markdown, JSON, YAML, CSS, HTML, etc.
			-- FIX: As of now, prettier (and, therefore, prettierd) doens't run smoothly on .vue files, because of things like:
			--
			-- @hide="
			--     a = false;
			--     b = true;
			-- "
			--
			-- and also things like:
			--
			-- {{
			--     a > 0
			--     ? length + (length !== 1 ? ' apples' : ' apple')
			--     : 'No text'
			-- }}
			--
			-- Ideally, prettierd would be enabled in .vue files if it didn't create any such issues
			disabled_filetypes = { "vue" },
		}),

		-- JSON
		require("null-ls").builtins.diagnostics.jsonlint,

		-- YAML
		require("null-ls").builtins.diagnostics.yamllint,

		-- Markdown
		require("null-ls").builtins.diagnostics.markdownlint,

		-- Make/CMake
		require("null-ls").builtins.formatting.cmake_format,
	},
})
