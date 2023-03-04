local mappings = require("mappings")

M = {
	"liuchengxu/vista.vim",
	cmd = "Vista",
}

function M.init()
	mappings.register_normal({
		v = { "<cmd>Vista<cr>", "Vista" },
	})
end

function M.config()
	vim.g.vista_default_executive = "nvim_lsp"
	vim.g["vista#renderer#enable_icon"] = 1
end

return M
