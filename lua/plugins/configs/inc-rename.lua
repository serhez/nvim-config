local mappings = require("mappings")

local M = {
	"smjonas/inc-rename.nvim",
	event = "BufRead",
}

function M.init()
	mappings.register({ "<leader>cr", ":IncRename ", desc = "Rename" })
end

function M.config()
	require("inc_rename").setup({
		save_in_cmdline_history = false,
	})
end

return M
