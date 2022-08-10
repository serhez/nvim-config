-- NOTE: You can discover all highlight groups the current colorscheme defines by executing ':hi'
-- TODO: Redefine DAP UI colours (these ones: https://github.com/rcarriga/nvim-dap-ui/blob/master/lua/dapui/config/highlights.lua)

local M = {}

-- Catppuccin
vim.g.catppuccin_flavour = "latte"

-- Github
vim.g.github_function_style = "italic"
vim.g.github_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Tokyonight
vim.g.tokyonight_style = "day"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Colorscheme
vim.cmd("let g:nvcode_termcolors=256")
vim.g.syntax = true
vim.g.colors_name = "rose-pine"
vim.cmd("set background=light")

-- Fixes to default highlight groups
vim.cmd("hi! link NonText LineNr")
vim.cmd("hi! link EndOfBuffer Normal")
vim.cmd([[let &fcs='eob: ']]) -- remove the tilde (~) after EOF

-- Word under cursor highlighting
local cursor_bg = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("CursorLine")), "bg")', true)
vim.cmd("hi LspReferenceRead gui=underline guibg=" .. cursor_bg)
vim.cmd("hi LspReferenceText gui=underline guibg=" .. cursor_bg)
vim.cmd("hi LspReferenceWrite gui=underline guibg=" .. cursor_bg)

-- Autogenerated highlight groups based on current colorscheme

local function highlight(group, color)
    local style = color.style and "gui=" .. color.style or "gui=NONE"
    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
    local sp = color.sp and "guisp=" .. color.sp or ""
    local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
    vim.cmd(hl)

    if color.link then
        vim.cmd("highlight! link " .. group .. " " .. color.link)
    end
end

local function fromhl(hl)
    local result = {}
    local list = vim.api.nvim_get_hl_by_name(hl, true)
    for k, v in pairs(list) do
        local status, res = pcall(string.format, "#%06x", v)
        if status then
            local name = k == "background" and "bg" or "fg"
            result[name] = res
        end
    end
    return result
end

local function term(num, default)
    local key = "terminal_color_" .. num
    return vim.g[key] and vim.g[key] or default
end

local function colors_from_theme()
    return {
        bg = fromhl("Normal").bg,
        fg = fromhl("Normal").fg,
        alt_bg = fromhl("CursorLine").bg,
        alt_fg = fromhl("CursorLine").bg,
        statusline_bg = fromhl("StatusLine").bg,
        statusline_fg = fromhl("StatusLine").fg,
        hint = fromhl("DiagnosticHint").fg or "#5E81AC",
        info = fromhl("DiagnosticInfo").fg or "#81A1C1",
        warn = fromhl("DiagnosticWarn").fg or "#EBCB8B",
        err = fromhl("DiagnosticError").fg or "#EC5F67",
        black = term(0, "#434C5E"),
        red = term(1, "#EC5F67"),
        green = term(2, "#8FBCBB"),
        yellow = term(3, "#EBCB8B"),
        blue = term(4, "#5E81AC"),
        magenta = term(5, "#B48EAD"),
        cyan = term(6, "#88C0D0"),
        white = term(7, "#ECEFF4"),
    }
end

-- This function must be called on an autocmd when the colorscheme is changed
-- After the function is called, UI components using these highlight groups must also be reloaded
M.gen_highlights = function()
    local c = colors_from_theme()
    M.colors = c

    M.groups = {
        -- Native
        FloatBorder = { fg = c.cyan, bg = c.statusline_bg },
        NormalFloat = { bg = c.statusline_bg },

        -- Bufferline
        BufferLineBufferSelected = { style = "bold" },

        -- Feline
        FlnViBlack = { fg = c.white, bg = c.black, style = "bold" },
        FlnViRed = { fg = c.statusline_bg, bg = c.red, style = "bold" },
        FlnViGreen = { fg = c.statusline_bg, bg = c.green, style = "bold" },
        FlnViYellow = { fg = c.statusline_bg, bg = c.yellow, style = "bold" },
        FlnViBlue = { fg = c.statusline_bg, bg = c.blue, style = "bold" },
        FlnViMagenta = { fg = c.statusline_bg, bg = c.magenta, style = "bold" },
        FlnViCyan = { fg = c.statusline_bg, bg = c.cyan, style = "bold" },
        FlnViWhite = { fg = c.statusline_bg, bg = c.white, style = "bold" },

        FlnBlack = { fg = c.black, bg = c.white },
        FlnRed = { fg = c.red, bg = c.statusline_bg },
        FlnGreen = { fg = c.green, bg = c.statusline_bg },
        FlnYellow = { fg = c.yellow, bg = c.statusline_bg },
        FlnBlue = { fg = c.blue, bg = c.statusline_bg },
        FlnMagenta = { fg = c.magenta, bg = c.statusline_bg },
        FlnCyan = { fg = c.cyan, bg = c.statusline_bg },
        FlnWhite = { fg = c.white, bg = c.statusline_bg },

        FlnHint = { fg = c.hint, bg = c.statusline_bg },
        FlnInfo = { fg = c.info, bg = c.statusline_bg },
        FlnWarn = { fg = c.warn, bg = c.statusline_bg },
        FlnError = { fg = c.err, bg = c.statusline_bg },
        FlnStatus = { fg = c.statusline_fg, bg = c.statusline_bg, style = "bold" },

        FlnText = { fg = c.statusline_fg, bg = c.statusline_bg },
        FlnBoldText = { fg = c.statusline_fg, bg = c.statusline_bg, style = "bold" },
        FlnSep = { fg = c.statusline_fg, bg = c.statusline_bg },
        FlnGitBranch = { fg = c.statusline_fg, bg = c.statusline_bg },
        FlnNavic = { fg = c.statusline_fg, bg = c.statusline_bg },

        -- LSPSaga
        LspFloatWinNormal = { bg = c.statusline_bg },
        LspFloatWinBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaBorderTitle = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaLspFinderBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaAutoPreview = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaRenameBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaHoverBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaSignatureHelpBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaCodeActionBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaDefPreviewBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspLinesDiagBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaDiagnosticBorder = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaDiagnosticTruncateLine = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaShTruncateLine = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaDocTruncateLine = { fg = c.cyan, bg = c.statusline_bg },
        LspSagaCodeActionTruncateLine = { fg = c.cyan, bg = c.statusline_bg },

        -- Coverage
        CoverageCovered = { fg = c.bg, bg = c.green },
        CoverageUncovered = { fg = c.bg, bg = c.red },

        -- Telescope
        TelescopeBorder = { fg = c.cyan, bg = c.statusline_bg },
        TelescopeNormal = { fg = c.fg, bg = c.statusline_bg },
        TelescopePromptNormal = { fg = c.fg, bg = c.statusline_bg },
        TelescopePromptPrefix = { fg = c.cyan, bg = c.statusline_bg },
        TelescopePromptCounter = { fg = c.fg, bg = c.statusline_bg },
        TelescopeSelection = { default = true, link = "Visual" },
        TelescopeSelectionCaret = { default = true, link = "Visual" },
        TelescopeMultiSelection = { default = true, link = "Visual" },

        -- CMP
        CmpItemMenu = { style = "italic" },
    }

    for k, v in pairs(M.groups) do
        highlight(k, v)
    end
end

M.gen_highlights()

return M
