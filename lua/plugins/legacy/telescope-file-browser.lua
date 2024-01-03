local M = {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	cmd = "Telescope file_browser",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		E = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true theme=ivy<cr>", "Explorer (telescope)" },
	})
end

function M.setup()
	local present, telescope = pcall(require, "telescope")
	if present then
		telescope.load_extension("file_browser")
	end
end

return M
