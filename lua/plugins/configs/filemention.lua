local M = {
	"not-manu/filemention.nvim",
	event = "InsertEnter",
	dependencies = { "dmtrKovalenko/fff.nvim" },
	ft = { "markdown" },
	opts = { finder = "fff" },
}

return M
