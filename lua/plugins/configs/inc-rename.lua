local M = {
	"smjonas/inc-rename.nvim",
	cmd = "IncRename",
}

function M.init()
	require("mappings").register({ "<leader>cr", ":IncRename ", desc = "Rename" })
end

function M.config()
	require("inc_rename").setup({
		save_in_cmdline_history = false,
	})
end

return M
