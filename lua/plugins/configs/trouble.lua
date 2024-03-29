local M = {
	"folke/trouble.nvim",
	branch = "dev", -- NOTE: for v.3 until it's merged to master
	cmd = "Trouble",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		c = {
			d = {
				w = { "<cmd>Trouble diagnostics toggle<cr>", "Workspace" },
				f = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "File" },
			},
		},
	})
end

function M.config()
	require("trouble").setup({
		pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
		focus = true, -- Focus the window when opened
		follow = true, -- Follow the current item
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		TroubleNormal = { bg = c.statusline_bg, fg = c.statusline_fg },
	})
end

return M
