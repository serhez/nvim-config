local M = {
	"axkirillov/hbac.nvim",
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register({
		{ "<leader>bl", "<cmd>Telescope hbac buffers theme=ivy<cr>", desc = "List" },
		{
			"<leader>bp",
			function()
				require("hbac"):toggle_pin()
				local present, bufferline = pcall(require, "bufferline")
				if present then
					bufferline.groups:toggle_pin()
				end
			end,
			desc = "Toggle pin",
		},
		{ "<leader>bca", "<cmd>lua require('hbac').close_unpinned()<cr>", desc = "All (unpinned)" },
	})
end

function M.config()
	require("hbac").setup({
		autoclose = true, -- set autoclose to false if you want to close manually
		threshold = 7, -- hbac will start closing unedited buffers once that number is reached
		close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
	})

	-- disable autopinning
	-- make sure this is after the setup call
	vim.api.nvim_del_augroup_by_name(require("hbac.autocommands").autopin.name)
end

return M
