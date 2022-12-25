local icons = require("icons")

local M = {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
}

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" " .. icons.arrow.down_left .. " %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
end

function M.config()
    vim.o.fillchars = "eob: ,fold: ,foldopen:"
        .. icons.arrow.down_short
        .. ",foldsep: ,foldclose:"
        .. icons.arrow.right_short
    vim.o.foldcolumn = "2"
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = -1
    vim.o.foldenable = true

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

    require("ufo").setup({
        provider_selector = function(_, _)
            -- return a string type use ufo providers
            -- return a string in a table like a string type
            -- return empty string '' will disable any providers
            -- return `nil` will use default value {'lsp', 'indent'}
            return ""
        end,
        fold_virt_text_handler = handler,
    })

    -- buffer scope handler
    -- will override global handler if it is existed
    local bufnr = vim.api.nvim_get_current_buf()
    require("ufo").setFoldVirtTextHandler(bufnr, handler)
end

return M
