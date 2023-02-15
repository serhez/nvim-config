local M = {
	"s1n7ax/nvim-window-picker",
	version = "v1.*",
}

function M.config()
	require("window-picker").setup()
end

return M
