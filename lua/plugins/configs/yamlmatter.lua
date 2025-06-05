-- NOTE: This plugin is triggered by render-markdown.nvim
local M = {
	"ray-x/yamlmatter.nvim",
	enabled = false, -- BUG: it's annoying because disabling does not work well
}

function M.config()
	require("yamlmatter").setup()
end

return M
