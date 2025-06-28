local M = {
	"nosduco/remote-sshfs.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	cmd = {
		"RemoteSSHFSConnect",
	},
	enabled = false,
}

function M.init()
	require("mappings").register({
		{ "<leader>x", group = "Remote" },
		{ "<leader>xs", "<cmd>RemoteStart<cr>", desc = "Start" },
		{ "<leader>xk", "<cmd>RemoteStop<cr>", desc = "Kill" },
		{ "<leader>xi", "<cmd>RemoteInfo<cr>", desc = "Info" },
		{ "<leader>xc", ":RemoteCleanup ", desc = "Cleanup" },
		{ "<leader>xd", ":RemoteConfigDel ", desc = "Delete cached config" },
	})
end

function M.config()
	require("telescope").load_extension("remote-sshfs")
	require("remote-sshfs").setup()
end

return M
