local M = {
	"uhs-robert/sshfs.nvim",
	cmd = { "SSHConnect" },
	enabled = false,
}

function M.init()
	require("mappings").register({
		{ "<leader>x", group = "Remote" },
		{ "<leader>xm", "<cmd>SSHConnect<cr>", desc = "Mount" },
		{ "<leader>xu", "<cmd>SSHDisconnect<cr>", desc = "Unmount" },
		{ "<leader>xe", "<cmd>SSHExplore<cr>", desc = "Explore" },
		{ "<leader>xd", "<cmd>SSHChangeDir<cr>", desc = "Change dir" },
		{ "<leader>xo", ":SSHCommand ", desc = "Run command" },
		{ "<leader>xc", "<cmd>SSHConfig<cr>", desc = "Edit config" },
		{ "<leader>xr", "<cmd>SSHReload<cr>", desc = "Reload" },
		{ "<leader>xf", "<cmd>SSHFiles<cr>", desc = "Files" },
		{ "<leader>xs", "<cmd>SSHGrep<cr>", desc = "Search" },
		{ "<leader>xS", "<cmd>SSHLiveGrep<cr>", desc = "Search (live)" },
		{ "<leader>xt", "<cmd>SSHTerminal<cr>", desc = "Terminal" },
	})
end

function M.config()
	vim.g.sshfs_mount_root = vim.fn.expand("~/mnt")

	require("sshfs").setup({
		connections = {
			-- SSHFS mount options (table of key-value pairs converted to sshfs -o arguments)
			-- Boolean flags: set to true to include, false/nil to omit
			-- String/number values: converted to key=value format
			sshfs_options = {
				reconnect = true, -- Auto-reconnect on connection loss
				ConnectTimeout = 30, -- Connection timeout in seconds
				compression = "yes", -- Enable compression
				ServerAliveInterval = 60, -- Keep-alive interval (e.g., 15s × 3 = 45s timeout)
				ServerAliveCountMax = 3, -- Keep-alive message count
				dir_cache = "yes", -- Enable directory caching
				dcache_timeout = 300, -- Cache timeout in seconds
				dcache_max_size = 10000, -- Max cache size
				dcache_stat_timeout = 300,
				dcache_link_timeout = 300,
				dcache_dir_timeout = 300,
				max_conns = 4,
			},
			control_persist = "10m", -- How long to keep ControlMaster connection alive after last use
		},
		mounts = {
			base_dir = vim.g.sshfs_mount_root,
		},
		hooks = {
			on_mount = {
				auto_change_to_dir = true, -- auto-change current directory to mount point
				auto_run = "live_find", -- "find", "grep", "live_find", "live_grep", "terminal", "none", or a custom function(ctx)
			},
		},
		ui = {
			local_picker = {
				preferred_picker = "oil", -- one of: "auto", "snacks", "fzf-lua", "mini", "telescope", "oil", "neo-tree", "nvim-tree", "yazi", "lf", "nnn", "ranger", "netrw"
			},
			remote_picker = {
				preferred_picker = "auto", -- one of: "auto", "snacks", "fzf-lua", "telescope", "mini"
			},
		},
		lead_prefix = "<leader>x", -- change keymap prefix
		keymaps = {
			mount = "<leader>xm", -- creates an ssh connection and mounts via sshfs
			unmount = "<leader>xu", -- disconnects an ssh connection and unmounts via sshfs
			explore = "<leader>xe", -- explore an sshfs mount using your native editor
			change_dir = "<leader>xd", -- change dir to mount
			command = "<leader>xo", -- run command on mount
			config = "<leader>xc", -- edit ssh config
			reload = "<leader>xr", -- manually reload ssh config
			files = "<leader>xf", -- browse files using chosen picker
			grep = "<leader>xg", -- grep files using chosen picker
			terminal = "<leader>xt", -- open ssh terminal session
		},
	})
end

return M
