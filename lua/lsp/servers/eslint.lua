local settings = {
    -- Do not use for Vue (use volar instead)
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },

    settings = {
        -- Do not use for formatting, use prettierd instead (through null-ls)
        format = false,

        -- npm is the default
        packageManager = "yarn",
    },
}

return settings
