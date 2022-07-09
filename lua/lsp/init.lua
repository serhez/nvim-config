local icons = require("icons")

local M = {}

local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

function M.setup()
    lspSymbol("Error", icons.diagnostics.error)
    lspSymbol("Info", icons.diagnostics.info)
    lspSymbol("Hint", icons.diagnostics.hint)
    lspSymbol("Warn", icons.diagnostics.warning)

    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
    })

    -- Suppress error messages from lang servers
    vim.notify = function(msg, log_level)
        if msg:match("exit code") then
            return
        end
        if log_level == vim.log.levels.ERROR then
            vim.api.nvim_err_writeln(msg)
        else
            vim.api.nvim_echo({ { msg } }, true, {})
        end
    end
end

-- Formatting

local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local auto_format_enabled = true -- Default

function M.toggle_auto_format()
    auto_format_enabled = not auto_format_enabled
end

-- TODO: When nvim 0.8 arrives, a new API for formatting will be available and you will be able to set it up as https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
-- NOTE: formatting_seq_sync() sequentially picks an LSP server to do formatting; it choses in the following order:
-- NOTE:    1. Servers that are not listed on the given list (so don't list the servers you want to do the formatting).
-- NOTE:    2. Servers that are on the list, in the order they appear there.
function M.format()
    vim.lsp.buf.formatting_seq_sync({}, 5000, {
        "gopls",
        "clangd",
        "jsonls",
        "sumneko_lua",
        "eslint_d",
        "eslint",
        "html",
        "cssls",
        "cmake",
        "pyright",
        "tailwindcss",
        "volar",
        "yamlls",
        "zeta_note",
        "vimls",
        "texlab",
        "lemminx",
        "dotls",
    })
end

function M.auto_format()
    if auto_format_enabled then
        M.format()
    end
end

function M.custom_attach(client, bufnr)
    require("illuminate").on_attach(client)

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Auto-format on save
    -- FIX: The if statement yields false for .ts files
    -- if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = formatting_augroup,
        buffer = bufnr,
        callback = function()
            require("lsp").auto_format()
        end,
    })
    -- end

    -- Mappings (some are commented as they are currently handled by plugins)
    vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = false, silent = true })
    vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = false, silent = true })
    -- vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = false, silent = true})
    vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = false, silent = true })
    vim.api.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = false, silent = true })
    -- vim.api.nvim_set_keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = false, silent = true})
    -- vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = false, silent = true})
    vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = false, silent = true })
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

-- Provide custom settings that should only apply to the following servers
M.enhance_server_opts = {
    ["eslint_d"] = require("lsp.eslint_d"),
    ["sumneko_lua"] = require("lsp.sumneko_lua"),
    ["volar"] = require("lsp.volar"),
}

return M
