local u = require("plugins.configs.feline.utils")
local lsp = require("feline.providers.lsp")
local gps = require("nvim-gps")

local function get_gps_location()
    local location = gps.get_location()
    if location == "" then
        return location
    else
        return ' > ' .. location
    end
end

local function vi_mode_hl()
    return u.vi_colors[vim.fn.mode()] or "FlnViBlack"
end

local function lsp_diagnostics_info()
    return {
        errors = lsp.get_diagnostics_count('ERROR'),
        warnings = lsp.get_diagnostics_count('WARN'),
        infos = lsp.get_diagnostics_count('INFO'),
        hints = lsp.get_diagnostics_count('HINT')
    }
end

local function lsp_diagnostics_show(severity)
    return function()
        return lsp.diagnostics_exist(severity)
    end
end

local function diag_of(f, s)
    local icon = u.icons[s]
    return function()
        local diag = f()[s]
        return icon .. ' ' .. diag
    end
end

local c = {
    default = { -- needed to pass the parent StatusLine hl group to right hand side
        provider = "",
        hl = "StatusLine",
    },
    vimode = {
        left = {
            provider = u.icons.double_space,
            hl = vi_mode_hl,
            right_sep = { str = u.icons.double_space, hl = "FlnSep" },
        },
        right = {
            provider = u.icons.double_space,
            hl = vi_mode_hl,
            left_sep = { str = u.icons.double_space, hl = "FlnSep" },
        },
    },
    git = {
        branch = {
            provider = "git_branch",
            icon = u.icons.branch .. ' ',
            hl = "FlnGitBranch",
            right_sep = { str = u.icons.single_space, hl = "FlnSep" },
            enabled = function()
                return vim.b.gitsigns_status_dict ~= nil
            end,
        },
        add = {
            provider = 'git_diff_added',
            hl = "FlnGreen",
        },
        change = {
            provider = 'git_diff_changed',
            hl = "FlnYellow",
        },
        remove = {
            provider = 'git_diff_removed',
            hl = "FlnRed",
        }
    },
    fileinfo = {
        provider = {
            name = "file_info",
            opts = {
                type = "base-only",
                file_readonly_icon = u.icons.lock .. ' ',
            }
        },
        hl = "FlnBoldText",
        left_sep = { hl = "FlnSep" },
        right_sep = { hl = "FlnSep" },
    },
    gps = {
        provider = function()
            return get_gps_location()
        end,
        enabled = function()
            return gps.is_available()
        end,
        hl = "FlnGPS",
    },
    diagnostics = {
        error = {
            provider = diag_of(lsp_diagnostics_info, 'errors'),
            enabled = lsp_diagnostics_show('ERROR'),
            hl = "FlnError",
        },
        warning = {
            provider = diag_of(lsp_diagnostics_info, 'warnings'),
            enabled = lsp_diagnostics_show('WARN'),
            left_sep = { str = u.icons.single_space, hl = "FlnSep" },
            hl = "FlnWarn",
        },
        info = {
            provider = diag_of(lsp_diagnostics_info, 'infos'),
            enabled = lsp_diagnostics_show('INFO'),
            left_sep = { str = u.icons.single_space, hl = "FlnSep" },
            hl = "FlnInfo",
        },
        hint = {
            provider = diag_of(lsp_diagnostics_info, 'hints'),
            enabled = lsp_diagnostics_show('HINT'),
            left_sep = { str = u.icons.single_space, hl = "FlnSep" },
            hl = "FlnHint",
        },
    },
    cursor = {
        position = {
            provider = "position",
            hl = "FlnText",
            left_sep = { str = u.icons.double_space, hl = "FlnSep" },
        },
        percentage = {
            provider = 'line_percentage',
            left_sep = { str = u.icons.double_space, hl = "FlnSep" },
            hl = "FlnText",
        },
    },
    in_fileinfo = {
        provider = {
            name = "file_info",
            opts = {
                type = "relative",
                file_readonly_icon = u.icons.lock .. ' ',
            }
        },
        hl = "StatusLine",
        left_sep = { hl = "FlnSep" },
        right_sep = { hl = "FlnSep" },
    },
}

local active = {
    { -- left
        c.vimode.left,
        c.git.branch,
        c.git.add,
        c.git.change,
        c.git.remove,
    },
    { -- center
        c.fileinfo,
        c.gps,
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

local inactive = {
    { c.default },     -- left
    { c.in_fileinfo }, -- center
    { c.default },     -- right
}

require("feline").setup({
    components = { active = active, inactive = inactive },
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

