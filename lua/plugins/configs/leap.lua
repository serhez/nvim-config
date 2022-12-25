local M = {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    dependencies = {
        "ggandor/flit.nvim",
        "ggandor/leap-spooky.nvim",
    },
}

function M.config()
    require("leap").add_default_mappings()
end

return M
