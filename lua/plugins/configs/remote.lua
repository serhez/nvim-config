local M = {
	"niuiic/remote.nvim",
	dependencies = { "niuiic/core.nvim" },
	cmd = "RemoteConnect",
}

function M.init()
	vim.cmd("command! RemoteConnect lua require('remote').connect()")
end

function M.config()
	require("remote").setup({
		config_file = ".nvim/remote.json",
		log_file = ".nvim/remote.log",

		unmount = function(path)
			return "umount " .. path
		end,
		disconnect_on_leave = true,

		---@type fun(config: remote.Config)
		on_each_to_connect = function() end,

		---@type fun(config: remote.Config)
		on_each_connected = function() end,

		---@type fun(config: remote.Config)
		on_each_to_disconnect = function() end,

		---@type fun(config: remote.Config)
		on_each_disconnected = function() end,
	})
end

return M
