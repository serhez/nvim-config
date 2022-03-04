local M = {}

local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

function M.setup()
    lspSymbol("Error", "")
    lspSymbol("Info", "")
    lspSymbol("Hint", "")
    lspSymbol("Warn", "")

    vim.diagnostic.config {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
    })

    -- Suppress error messages from lang servers
    vim.notify = function(msg, log_level)
        if msg:match "exit code" then
            return
        end
        if log_level == vim.log.levels.ERROR then
            vim.api.nvim_err_writeln(msg)
        else
            vim.api.nvim_echo({ { msg } }, true, {})
        end
    end
end

function M.custom_attach(client, bufnr)
    require 'illuminate'.on_attach(client)

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Auto-format on save
    -- NOTE: vim.lsp.buf.formatting_seq_sync() sequentially picks an LSP server to do formatting; it choses in the following order:
    -- NOTE:    1. Servers that are not listed on the given list (so don't list the servers you want to do the formatting).
    -- NOTE:    2. Servers that are on the list, in the order they appear there.
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
        augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync({}, 2000, {'gopls', 'clangd', 'jsonls', 'sumneko_lua', 'eslint', 'html', 'cssls', 'cmake', 'pyright', 'tailwindcss', 'volar', 'yamlls', 'zeta_note', 'vimls', 'texlab', 'lemminx', 'dotls',})
        augroup END
        ]])
    end

    -- Mappings (some are commented as they are currently handled by plugins)
    vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", {noremap = false, silent = true})
    vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = false, silent = true})
    vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = false, silent = true})
    vim.api.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = false, silent = true})
    vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = false, silent = true})
end

M.custom_capabilities = vim.lsp.protocol.make_client_capabilities()
M.custom_capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
M.custom_capabilities.textDocument.completion.completionItem.snippetSupport = true
M.custom_capabilities.textDocument.completion.completionItem.preselectSupport = true
M.custom_capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.custom_capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.custom_capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.custom_capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.custom_capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
M.custom_capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

-- Provide custom settings that should only apply to given servers
M.enhance_server_opts = {
    ["sumneko_lua"] = require "lsp.sumneko_lua"
}

return M

