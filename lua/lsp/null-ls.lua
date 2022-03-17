require("null-ls").setup({
    sources = {
        -- Lua
        require("null-ls").builtins.formatting.stylua,

        -- Python
        require("null-ls").builtins.formatting.isort,
        require("null-ls").builtins.diagnostics.pylint,

        -- C/C++
        require("null-ls").builtins.formatting.clang_format,
        require("null-ls").builtins.diagnostics.cppcheck,

        -- Golang
        require("null-ls").builtins.formatting.goimports,
        require("null-ls").builtins.diagnostics.golangci_lint,

        -- Javascript/Typescript
        -- require("null-ls").builtins.formatting.prettier.with({  -- Also Markdown, JSON, YAML, CSS, HTML, etc.
        --     disabled_filetypes = { "vue" },
        --     extra_args = {
        --         "--tab-width 4",
        --         "--print-width 120",
        --         "--embedded-language-formatting auto",
        --         "--single-quote",
        --     }
        -- }),

        -- JSON
        require("null-ls").builtins.diagnostics.jsonlint,

        -- Markdown
        require("null-ls").builtins.diagnostics.markdownlint,

        -- Make/CMake
        require("null-ls").builtins.formatting.cmake_format,
    },
})
