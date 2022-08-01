local icons = require("icons")
local utils = require("plugins.configs.feline.utils")
local lsp = require("feline.providers.lsp")
local navic = require("nvim-navic")

local function get_navic_location()
    local location = navic.get_location()
    if location == "" then
        return location
    else
        return icons.single_space .. icons.arrow.right_short .. icons.single_space .. location
    end
end

local function vi_mode_hl()
    return utils.vi_colors[vim.fn.mode()] or "FlnViBlack"
end

local function lsp_diagnostics_info()
    return {
        error = lsp.get_diagnostics_count("ERROR"),
        warning = lsp.get_diagnostics_count("WARN"),
        info = lsp.get_diagnostics_count("INFO"),
        hint = lsp.get_diagnostics_count("HINT"),
    }
end

local function lsp_diagnostics_show(severity)
    return function()
        return lsp.diagnostics_exist(severity)
    end
end

local function diag_of(f, s)
    local icon = icons.diagnostics[s]
    return function()
        local diag = f()[s]
        return icon .. icons.single_space .. diag
    end
end

local c = {
    default = { -- needed to pass the parent StatusLine hl group to right hand side
        provider = "",
        hl = "StatusLine",
    },
    vimode = {
        left = {
            provider = icons.double_space,
            hl = vi_mode_hl,
            right_sep = { str = icons.double_space, hl = "FlnSep" },
        },
        right = {
            provider = icons.double_space,
            hl = vi_mode_hl,
            left_sep = { str = icons.double_space, hl = "FlnSep" },
        },
    },
    git = {
        branch = {
            provider = "git_branch",
            icon = icons.git.branch .. icons.single_space,
            hl = "FlnGitBranch",
            right_sep = { str = icons.single_space, hl = "FlnSep" },
            enabled = function()
                return vim.b.gitsigns_status_dict ~= nil
            end,
        },
        add = {
            provider = "git_diff_added",
            hl = "FlnGreen",
        },
        change = {
            provider = "git_diff_changed",
            hl = "FlnYellow",
        },
        remove = {
            provider = "git_diff_removed",
            hl = "FlnRed",
        },
    },
    fileinfo = {
        provider = {
            name = "file_info",
            opts = {
                type = "unique",
                file_readonly_icon = icons.lock .. icons.single_space,
            },
        },
        hl = "FlnBoldText",
        left_sep = { hl = "FlnSep" },
        right_sep = { hl = "FlnSep" },
    },
    navic = {
        provider = function()
            return get_navic_location()
        end,
        enabled = function()
            return navic.is_available()
        end,
        hl = "FlnNavic",
    },
    diagnostics = {
        error = {
            provider = diag_of(lsp_diagnostics_info, "error"),
            enabled = lsp_diagnostics_show("ERROR"),
            hl = "FlnError",
        },
        warning = {
            provider = diag_of(lsp_diagnostics_info, "warning"),
            enabled = lsp_diagnostics_show("WARN"),
            left_sep = { str = icons.single_space, hl = "FlnSep" },
            hl = "FlnWarn",
        },
        info = {
            provider = diag_of(lsp_diagnostics_info, "info"),
            enabled = lsp_diagnostics_show("INFO"),
            left_sep = { str = icons.single_space, hl = "FlnSep" },
            hl = "FlnInfo",
        },
        hint = {
            provider = diag_of(lsp_diagnostics_info, "hint"),
            enabled = lsp_diagnostics_show("HINT"),
            left_sep = { str = icons.single_space, hl = "FlnSep" },
            hl = "FlnHint",
        },
    },
    cursor = {
        position = {
            provider = "position",
            hl = "FlnText",
            left_sep = { str = icons.double_space, hl = "FlnSep" },
        },
        percentage = {
            provider = "line_percentage",
            left_sep = { str = icons.double_space, hl = "FlnSep" },
            hl = "FlnText",
        },
    },
    in_fileinfo = {
        provider = {
            name = "file_info",
            opts = {
                type = "relative",
                file_readonly_icon = icons.lock .. icons.single_space,
            },
        },
        hl = "StatusLine",
        left_sep = { hl = "FlnSep" },
        right_sep = { hl = "FlnSep" },
    },
}

local statusline_active = {
    { -- left
        c.vimode.left,
        c.git.branch,
        c.git.add,
        c.git.change,
        c.git.remove,
    },
    { -- center
        c.fileinfo,
        c.navic,
    },
    { -- right
        c.diagnostics.error,
        c.diagnostics.warning,
        c.diagnostics.info,
        c.diagnostics.hint,
        c.cursor.position,
        c.cursor.percentage,
        c.vimode.right,
    },
}

local statusline_inactive = {
    { c.default }, -- left
    { c.in_fileinfo }, -- center
    { c.default }, -- right
}

-- local winbar_active = {
--     { c.fileinfo },
-- }

require("feline").setup({
    components = { active = statusline_active, inactive = statusline_inactive },
    highlight_reset_triggers = {},
    force_inactive = {
        filetypes = {
            "help",
        },
        buftypes = { "terminal" },
        bufnames = {},
    },
    disable = {
        filetypes = {
            "packer",
            "dap-repl",
            "dapui_scopes",
            "dapui_stacks",
            "dapui_watches",
            "dapui_repl",
            "LspTrouble",
            "qf",
            "NvimTree",
            "vista_kind",
            "dashboard",
            "startify",
        },
    },
})

-- require("feline").winbar.setup()
