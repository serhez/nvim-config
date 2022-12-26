local mappings = require("mappings")

local M = {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
}

function M.init()
	vim.api.nvim_set_keymap("n", "y", "<Plug>(YankyYank)", { silent = true })
	vim.api.nvim_set_keymap("x", "y", "<Plug>(YankyYank)", { silent = true })
	vim.api.nvim_set_keymap("n", "p", "<Plug>(YankyPutAfterFilter)", { silent = true })
	vim.api.nvim_set_keymap("x", "p", "<Plug>(YankyPutAfterFilter)", { silent = true })
	vim.api.nvim_set_keymap("n", "P", "<Plug>(YankyPutBeforeFilter)", { silent = true })
	vim.api.nvim_set_keymap("x", "P", "<Plug>(YankyPutBeforeFilter)", { silent = true })
	vim.api.nvim_set_keymap("n", "gp", "<Plug>(YankyGPutAfterFilter)", { silent = true })
	vim.api.nvim_set_keymap("x", "gp", "<Plug>(YankyGPutAfterFilter)", { silent = true })
	vim.api.nvim_set_keymap("n", "gP", "<Plug>(YankyGPutBeforeFilter)", { silent = true })
	vim.api.nvim_set_keymap("x", "gP", "<Plug>(YankyGPutBeforeFilter)", { silent = true })
	vim.api.nvim_set_keymap("n", "<c-n>", "<Plug>(YankyCycleForward)", { silent = true })
	vim.api.nvim_set_keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)", { silent = true })

	mappings.register_normal({
		f = {
			y = { "<cmd>Telescope yank_history<cr>", "Yank history" },
		},
	})
end

function M.config()
	require("yanky").setup({
		highlight = {
			timer = 200,
		},
	})

	require("telescope").load_extension("yank_history")
end

return M
