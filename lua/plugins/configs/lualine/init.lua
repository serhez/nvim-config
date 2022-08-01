local gps = require("nvim-gps")

local function get_location()
    local location = gps.get_location
    if location == "" then
        return location
    else
        return " > " .. location
    end
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = " ", right = " " },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {
            "mode",
        },
        lualine_b = {
            "branch",
            "diff",
        },
        lualine_c = {
            "filetype",
            { "filename", path = 1, shorting_target = 100 },
            { get_location, cond = gps.is_available },
        },
        lualine_x = {
            "diagnostics",
        },
        lualine_y = {
            "location",
        },
        lualine_z = {
            "progress",
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = nil,
    extensions = nil,
    on_config_done = nil,
})
