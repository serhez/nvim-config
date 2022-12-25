local M = {
	"ggandor/leap-spooky.nvim",
}

function M.config()
	require("leap-spooky").setup({
		paste_on_remote_yank = true,
	})
end

return M
