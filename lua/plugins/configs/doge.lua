local M = {
	"kkoomen/vim-doge",
	cmd = "DogeGenerate",
}

function M.config()
	vim.g.doge_enable_mappings = 0
end

return M
