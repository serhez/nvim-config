require("null-ls").setup({
    sources = {
        -- Lua
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.luacheck,

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
        require("null-ls").builtins.formatting.prettierd, -- Also Markdown, JSON, YAML, CSS, HTML, etc.
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.code_actions.eslint,

        -- JSON
        require("null-ls").builtins.diagnostics.jsonlint,

        -- Markdown
        require("null-ls").builtins.diagnostics.markdownlint,

        -- Make/CMake
        require("null-ls").builtins.formatting.cmake_format,
    },
})
