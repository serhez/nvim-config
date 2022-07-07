local icons = require("icons")

require("incline").setup({
    render = function()
        return require("feline").providers.file_info({}, {
            type = "base-only",
            file_readonly_icon = icons.lock .. icons.single_space,
        })
    end,
})
