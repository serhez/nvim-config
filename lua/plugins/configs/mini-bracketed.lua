local M = {
	"echasnovski/mini.bracketed",
	version = false,
	event = "BufReadPost",
}

function M.config()
	require("mini.bracketed").setup()
end

return M
