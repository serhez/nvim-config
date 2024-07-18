local M = {
	"amitds1997/remote-nvim.nvim",
	version = "*", -- Pin to GitHub releases
	dependencies = {
		"nvim-lua/plenary.nvim", -- For standard functions
		"MunifTanjim/nui.nvim", -- To build the plugin UI
		"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
	},
	cmd = {
		"RemoteStart",
		"RemoteStop",
		"RemoteInfo",
		"RemoteCleanup",
		"RemoteConfigDel",
		"RemoteLog",
	},
}

function M.init()
	require("mappings").register({
		{ "<leader>x", group = "Remote" },
		{ "<leader>xs", "<cmd>RemoteStart<cr>", desc = "Start" },
		{ "<leader>xk", "<cmd>RemoteStop<cr>", desc = "Kill" },
		{ "<leader>xi", "<cmd>RemoteInfo<cr>", desc = "Info" },
		{ "<leader>xc", "<cmd>RemoteCleanup<cr>", desc = "Cleanup" },
	})
end

function M.config()
	require("remote-nvim").setup()
end

return M
