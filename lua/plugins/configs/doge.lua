local mappings = require("mappings")

local M = {
	"kkoomen/vim-doge",
	cmd = "DogeGenerate",
}

function M.init()
	mappings.register_normal({
		u = {
			D = { "<cmd>DogeGenerate<cr>", "Generate docs" },
		},
	})
end

function M.config()
	vim.g.doge_enable_mappings = 0
end

return M
