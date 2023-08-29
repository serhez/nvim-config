local M = {
	"echasnovski/mini.bracketed",
	event = "BufReadPost",
}

function M.config()
	require("mini.bracketed").setup()
end

return M
