local M = {
	"ray-x/yamlmatter.nvim",
	ft = { "markdown", "quarto", "rmd" },
}

function M.config()
	require("yamlmatter").setup()
end

return M
