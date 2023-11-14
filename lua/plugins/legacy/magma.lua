local M = {
	"meatballs/magma-nvim",
	build = ":UpdateRemotePlugins",
	-- NOTE: Currently, the plugin is only loaded as a dependency of the "notebook" plugin
}

function M.init()
	local mappings = require("mappings")

	mappings.register_normal({
		n = {
			c = {
				name = "Cell",
				r = { "<cmd>MagmaReevaluateCell<cr>", "Run" },
				s = { "<cmd>MagmaInterrupt<cr>", "Stop" },
			},
			i = { "<cmd>MagmaInit<cr>", "Init kernel" },
			k = { "<cmd>MagmaDeinit<cr>", "Kill kernel" },
			l = { "<cmd>MagmaEvaluateLine<cr>", "Run line" },
			L = { ":MagmaLoad ", "Load" },
			o = { "<cmd>MagmaShowOutput<cr>", "Show output" },
			O = { "<cmd>noautocmd MagmaEnterOutput<cr>", "Enter output" },
			r = { "<cmd>MagmaRestart!<cr>", "Restart kernel" },
			S = { ":MagmaSave ", "Save" },
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
