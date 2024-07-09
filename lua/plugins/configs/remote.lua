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
	require("mappings").register_normal({
		x = {
			name = "Remote",
			s = { "<cmd>RemoteStart<cr>", "Start" },
			k = { "<cmd>RemoteStop<cr>", "Kill" },
			i = { "<cmd>RemoteInfo<cr>", "Info" },
			c = { "<cmd>RemoteCleanup<cr>", "Cleanup" },
		},
	})
end

function M.config()
	require("remote-nvim").setup()
end

return M
