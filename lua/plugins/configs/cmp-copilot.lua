local M = {
    "zbirenbaum/copilot-cmp",
}

function M.config()
    require("copilot_cmp").setup({
        -- In the future, when the performance is better, we can try "getPanelCompletions"
        method = "getCompletionsCycling",
    })
end

return M