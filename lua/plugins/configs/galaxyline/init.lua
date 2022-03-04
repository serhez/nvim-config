-- local testing = require('testing')
local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local extensions = require('galaxyline.providers.extensions')
local gps = require("nvim-gps")
local gls = gl.section
gl.short_line_list = {'NvimTree','vista_kind','dbui'}

local function file_readonly()
    if vim.bo.filetype == 'help' then
        return ''
    end
    if vim.bo.readonly == true then
        return ' 🔒  '
    end
    return ''
end

local file_name = function()
    local file = vim.fn.expand('%:t')
    if vim.fn.empty(file) == 1 then return '' end
    if string.len(file_readonly()) ~= 0 then
        return file .. file_readonly()
    end
    if vim.bo.modifiable then
        if vim.bo.modified then
            return file .. ' 🖉 '
        end
    end
    return file
end

local mode_color = {
    n = 'Special',
    no = 'Special',
    s = 'Boolean',
    S = 'Boolean',
    i = 'Keyword',
    ic = 'Keyword',
    V = 'Constant',
    v = 'Constant',
    [""] = 'Boolean',
    c = 'Identifier',
    cv = 'Identifier',
    ce = 'Identifier',
    t = 'PreProc',
    r = 'Identifier',
    R = 'Identifier',
    Rv = 'Identifier',
    ["!"] = 'Identifier',
}

-- Read from testing.lua module
-- and adjust icon and color per testing state
-- local testing_results = function ()
--   local test_colors = {
--     init = 'Comment',
--     passing = 'Type',
--     running = 'Constant',
--     failing = 'Keyword'
--   }

-- vim.api.nvim_command('hi link GalaxyTestResults ' ..test_colors[testing.TESTING_STATUS])
-- 
--   if testing.TESTING_STATUS == 'init' then
--     return " "
--   elseif testing.TESTING_STATUS == 'passing' then
--     return " "
--   elseif testing.TESTING_STATUS == 'running' then
--     return " "
--   elseif testing.TESTING_STATUS == 'failing' then
--     return " "
--   end
-- 
-- end

-----------------------------------------------------------
-- Bar Sections
-----------------------------------------------------------

-- LEFT
-----------------------------------------------------------
gls.left[1] = {
    ViMode = {
        provider = function()
            vim.api.nvim_command('hi link GalaxyViMode ' .. mode_color[vim.fn.mode()])
            return '█'
        end,
        separator = '   '
    }
}

gls.left[2] = {
    GitIcon = {
        provider = function()
            return ''
        end,
        separator = ' ',
        condition = condition.check_git_workspace,
        -- highlight = function()
        --     if condition.check_git_workspace() then
        --         return "Identifier"
        --     else
        --         return "Comment"
        --     end
        -- end
    }
}

gls.left[3] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = condition.check_git_workspace,
        separator = '   ',
    }
}

gls.left[4] = {
    DiffAdd = {
        provider = 'DiffAdd',
        -- condition = condition.hide_in_width,
        icon = '  ',
        highlight = 'String'
    }
}

gls.left[5] = {
    DiffModified = {
        provider = 'DiffModified',
        -- condition = condition.hide_in_width,
        icon = ' 柳',
        highlight = 'PreProc'
    }
}

gls.left[6] = {
    DiffRemove = {
        provider = 'DiffRemove',
        -- condition = condition.hide_in_width,
        icon = '  ',
        highlight = 'Keyword'
    }
}


-- MID
-----------------------------------------------------------
gls.mid[1] ={
    FileIcon = {
        provider = 'FileIcon',
        condition = condition.buffer_not_empty,
        highlight = {require('galaxyline.providers.fileinfo').get_file_icon_color, 'NONE'},
    }
}

gls.mid[2] = {
    FileName = {
        provider = file_name,
        condition = condition.buffer_not_empty,
        highlight = {'Constant', 'NONE', 'bold'}
    }
}

gls.mid[3] = {
    nvimGPS = {
		provider = function()
            if gps.get_location() == "" then
                return ""
            else
                return "> " .. gps.get_location()
            end
		end,
		condition = function()
			return gps.is_available() and condition.hide_in_width()
		end,
        separator = ' ',
        highlight = 'Constant'
	}
}


-- RIGHT
-----------------------------------------------------------

-- gls.right[1] = {
--   TestResults = {
--     provider = testing_results
--   }
-- }

gls.right[1] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = 'Keyword'
    }
}

gls.right[2] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = 'Boolean'
    }
}

gls.right[3] = {
    DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ',
        highlight = 'Special'
    }
}

gls.right[4] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ',
        highlight = 'Constant'
    }
}

gls.right[5] = {
    LineInfo = {
        provider = function ()
            local line = vim.fn.line('.')
            local column = vim.fn.col('.')
            return string.format("%d:%d", line, column)
        end,
        separator = '   ',
    }
}

gls.right[6] = {
    ScrollBar = {
        provider = function()
            vim.api.nvim_command('hi link GalaxyScrollBar ' .. mode_color[vim.fn.mode()])
            local custom_scrollbar_chars = {'▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
            return extensions.scrollbar_instance(custom_scrollbar_chars)
        end,
        separator = '   ',
        -- highlight = function()
        --     return mode_color[vim.fn.mode()]
        -- end
    }
}

-- SHORTLINE
-----------------------------------------------------------
gls.short_line_left[1] = {
    FileName = {
        provider = 'FileName',
        highlight = 'PreProc'
    }
}

if (os.getenv("NO_SHOW_STATUSLINE")) then
    gls.left = {}
    gls.right = {}
end
