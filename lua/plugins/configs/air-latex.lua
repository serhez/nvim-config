local M = {
	"da-h/AirLatex.vim",
	cmd = "AirLatex",
	build = "<cmd>UpdateRemotePlugins<cr>",
}

function M.init()
	require("mappings").register({
		{ "<leader>M", group = "Markdown" },
		{ "<leader>Mc", "<cmd>AirLatex<cr>", desc = "Connect to remote" },
	})
end

function M.config()
	vim.g.AirLatexUsername = "sergiohdez97@gmail.com"
	vim.g.AirLatexDomain = "www.overleaf.com"
	vim.g.AirLatexLogLevel = "NOTSET"
end

return M
