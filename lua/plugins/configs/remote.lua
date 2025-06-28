-- NOTE: This plugin automatically installs telescope
--       even without it being listed in `dependencies`
local M = {
	-- "amitds1997/remote-nvim.nvim",
	"hmk114/remote-nvim.nvim", -- FIX: contains an unmerged PR that fixes the plugin
	version = "*", -- Pin to GitHub releases
	dependencies = {
		"nvim-lua/plenary.nvim", -- For standard functions
		"MunifTanjim/nui.nvim", -- To build the plugin UI
	},
	cmd = {
		"RemoteStart",
		"RemoteStop",
		"RemoteInfo",
		"RemoteCleanup",
		"RemoteConfigDel",
		"RemoteLog",
	},
	-- enabled = false,
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
	require("remote-nvim").setup({
		remote = {
			copy_dirs = {
				config = {
					dirs = { "after", "lua", "scripts", "syntax" },
				},
			},
		},
	})
end

return M
