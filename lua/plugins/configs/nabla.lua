local M = {
	"jbyuki/nabla.nvim",
	ft = {
		"tex",
		"markdown",
		"pandoc",
		"quarto",
		"latex",
		"rmd",
	},
}

function M.init()
	local mappings = require("mappings")

	vim.api.nvim_create_user_command("Nabla", "lua require('nabla').popup()", {})

	-- 	BUG: At the moment, this triggers a Treesitter error
	-- require("nabla").enable_virt()

	mappings.register_normal({
		l = {
			p = { "<cmd>Nabla<cr>", "Preview formula" },
		},
	})
end

return M
