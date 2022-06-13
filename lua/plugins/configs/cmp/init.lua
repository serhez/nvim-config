local present, cmp = pcall(require, "cmp")

if not present then
    return
end

local luasnip_present, luasnip = pcall(require, "luasnip")

cmp.setup({
    -- Disable for comments
    enabled = function ()
        local context = require 'cmp.config.context'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
    end,
    completion = {
        completeopt = "menuone,noselect",
    },
    preselect = cmp.PreselectMode.None,
    window = {
        documentation = cmp.config.window.bordered(),
    },
    snippet = (luasnip_present and {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    }) or {
        expand = function(_) end,
    },
    formatting = {
        format = function(entry, vim_item)
            local icons = require "plugins.configs.cmp.icons"
            vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                cmp_tabnine = "[Tabnine]",
                path = "[Path]",
            })[entry.source.name]

            return vim_item
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip_present and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    -- Order matters: it will determine the prioritization of sources when showing autocomplete suggestions
    sources = {
        { name = "luasnip" },
        { name = "cmp_tabnine" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "dap" },
    },
    -- TODO: Ideally, we would remove the comparators we don't want instead of adding the ones we do, so that when new ones are added we don't miss them
    -- sorting = {
    --     comparators = {
    --         cmp.config.compare.offset,
    --         cmp.config.compare.exact,
    --         cmp.config.compare.score,
    --         cmp.config.compare.recently_used,
    --         cmp.config.compare.kind,
    --         cmp.config.compare.sort_text,
    --         cmp.config.compare.length,
    --         cmp.config.compare.order,
    --         cmp.config.compare.locality,
    --         cmp.config.compare.scopes,
    --     },
    -- },
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
