local mappings = require("mappings")

local M = {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	cmd = "Neogen",
	enabled = false,
}

function M.init()
	mappings.register_normal({
		c = {
			D = { "<cmd>Neogen<cr>", "Generate docs" },
		},
	})
	mappings.register_visual({
		c = {
			D = { "<cmd>Neogen<cr>", "Generate docs" },
		},
	})
end

function M.config()
	require("neogen").setup({
		snippet_engine = "luasnip",
	})
end

return M
