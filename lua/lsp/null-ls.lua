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
        require("null-ls").builtins.formatting.prettier, -- Also Markdown, JSON, YAML, CSS, HTML, etc.

        -- JSON
        require("null-ls").builtins.diagnostics.jsonlint,

        -- Markdown
        require("null-ls").builtins.diagnostics.markdownlint,

        -- Make/CMake
        require("null-ls").builtins.formatting.cmake_format,
    },
})
