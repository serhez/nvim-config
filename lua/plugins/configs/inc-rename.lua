local mappings = require("mappings")

local M = {
	"smjonas/inc-rename.nvim",
	event = "BufRead",
}

function M.init()
	mappings.register_normal({
		c = {
			r = { ":IncRename ", "Rename" },
		},
	})
end

function M.config()
	require("inc_rename").setup()
end

return M
