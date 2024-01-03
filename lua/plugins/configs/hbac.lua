local M = {
	"axkirillov/hbac.nvim",
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		b = {
			l = { "<cmd>Telescope hbac buffers theme=ivy<cr>", "List" },
			p = {
				function()
					require("hbac"):toggle_pin()
					local present, bufferline = pcall(require, "bufferline")
					if present then
						bufferline.groups:toggle_pin()
					end
				end,
				"Toggle pin",
			},
			c = {
				a = { "<cmd>lua require('hbac').close_unpinned()<cr>", "All (unpinned)" },
			},
		},
		F = {
			b = { "<cmd>Telescope hbac buffers theme=ivy<cr>", "Buffers" }, -- Redundancy
		},
	})
end

function M.config()
	require("hbac").setup({
		autoclose = true, -- set autoclose to false if you want to close manually
		threshold = 6, -- hbac will start closing unedited buffers once that number is reached
		close_buffers_with_windows = true, -- hbac will close buffers with associated windows if this option is `true`
	})

	require("telescope").load_extension("hbac")
end

return M
