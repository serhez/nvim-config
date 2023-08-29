local M = {
	"folke/edgy.nvim",
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	require("mappings").register_normal({
		e = { "<cmd>lua require('edgy').toggle('left')<cr>", "Explorer" },
	})
end

function M.config()
	local icons = require("icons")

	require("edgy").setup({
		exit_when_last = true,
		icons = {
			closed = " " .. icons.arrow.right_short_thick,
			open = " " .. icons.arrow.down_short_thick,
		},
		animate = {
			enabled = false,
			fps = 60, -- frames per second
			cps = 120, -- cells per second
		},

		options = {
			left = { size = 45 },
			bottom = { size = 10 },
			right = { size = 45 },
			top = { size = 10 },
		},

		left = {
			{
				title = icons.file.files .. " Files",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				pinned = true,
				open = "Neotree position=left filesystem",
				size = { height = 0.6 },
			},
			{
				title = icons.git.github .. " Git",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "git_status"
				end,
				pinned = true,
				open = "Neotree position=right git_status",
				size = { height = 0.2 },
			},
			{
				title = icons.window .. " Buffers",
				ft = "vuffers",
				pinned = true,
				open = "lua require('vuffers').open()",
				size = { height = 0.2 },
			},
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		EdgyNormal = { fg = c.statusline_fg, bg = c.statusline_bg },
		EdgyWinBar = { bg = c.statusline_bg },
		EdgyTitle = { bg = c.bg, fg = c.title_fg },
		EdgyIcon = { bg = c.bg, fg = c.signcolumn_fg },
		EdgyIconActive = { bg = c.bg, fg = c.constant_fg },
	})
end

return M
