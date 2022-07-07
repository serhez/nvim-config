local lsp_config = require("lsp")

-- LSP config for each language
local setup_lsp = function(attach, capabilities, enhance_server_opts)
    local present, lsp_installer = pcall(require, "nvim-lsp-installer")

    if not present then
        return
    end

    lsp_installer.on_server_ready(function(server)
        local opts = {
            on_attach = attach,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            },
        }

        if enhance_server_opts[server.name] then
            -- Enhance the default opts with the server-specific ones
            opts.settings = enhance_server_opts[server.name]
        end

        server:setup(opts)
        vim.cmd([[ do User LspAttachBuffers ]])
    end)
end

setup_lsp(lsp_config.custom_attach, lsp_config.custom_capabilities, lsp_config.enhance_server_opts)
