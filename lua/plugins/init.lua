local M = {}

function M.setup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--single-branch",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
	end

	vim.opt.runtimepath:prepend(lazypath)

	require("lazy").setup("plugins.configs", {
		defaults = {
			lazy = true,
		},
		dev = {
			-- directory where you store your local plugin projects
			path = "~/dev",
		},
		ui = {
			border = "none",
		},
		git = {
			timeout = 300, -- 5 minutes
		},
		-- BUG: luarocks is broken, remove the options below once fixed
		rocks = {
			server = "https://lumen-oss.github.io/rocks-binaries/",
			enabled = false,
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"netrw",
					"netrwPlugin",
					"netrwSettings",
					"netrwFileHandlers",
					"gzip",
					"zip",
					"zipPlugin",
					"tar",
					"tarPlugin",
					"getscript",
					"getscriptPlugin",
					"vimball",
					"vimballPlugin",
					"2html_plugin",
					"logipat",
					"rrhelper",
					"spellfile_plugin",
					"matchit",
				},
			},
		},
	})

	require("mappings").register({ "<leader>ip", "<cmd>Lazy<cr>", desc = "Plugins panel" })
end

return M
