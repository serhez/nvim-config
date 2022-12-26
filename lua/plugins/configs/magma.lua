local mappings = require("mappings")

local M = {
	"dccsillag/magma-nvim",
	build = ":UpdateRemotePlugins",
	fp = "ipynb",
}

function M.init()
	mappings.register_normal({
		n = {
			c = { "<cmd>MagmaReevaluateCell<cr>", "Run cell" },
			d = { "<cmd>MagmaDelete<cr>", "Delete cell" },
			i = { "<cmd>MagmaInit python3<cr>", "Init" },
			l = { "<cmd>MagmaEvaluateLine<cr>", "Run line" },
			o = { "<cmd>MagmaShowOutput<cr>", "Show output" },
			r = { "<cmd>MagmaRestart!<cr>", "Restart kernel" },
		},
	})
	mappings.register_visual({
		n = {
			r = { "<cmd>MagmaEvaluateVisual<cr>", "Run" },
		},
	})
end

function M.config()
	vim.g.magma_automatically_open_output = false
	vim.g.magma_image_provider = "ueberzug"
end

return M
