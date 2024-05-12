local M = {
	"ptdewey/yankbank-nvim",
	cmd = "YankBank",
}

function M.init()
	require("mappings").register_normal({
		y = { "<cmd>YankBank<cr>", "Yank history" },
	})
end

function M.config()
	require("yankbank").setup()
end

return M
