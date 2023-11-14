local M = {
	"benlubas/molten-nvim",
	-- dependencies = { "3rd/image.nvim" },
	build = ":UpdateRemotePlugins",
	event = "BufRead *.ipynb",
}

function M.init()
	vim.g.molten_image_provider = "image.nvim"
	vim.g.molten_output_win_max_height = 20
	vim.g.molten_auto_open_output = false
end

function M.config()
	vim.api.nvim_create_autocmd({ "BufReadPost" }, { pattern = { "*.ipynb" }, command = "MoltenInit" })
end

return M
