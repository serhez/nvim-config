local M = {
	"serhez/overleaf.nvim",
	dev = true,
	build = "cd node && npm install",
	cmd = "Overleaf",
}

function M.init()
	require("mappings").register({
		{ "<leader>o", group = "Overleaf" },
		{
			"<leader>oo",
			"<cmd>Overleaf projects<cr>",
			desc = "Open project",
		},
		{
			"<leader>os",
			"<cmd>Overleaf status<cr>",
			desc = "Status",
		},
		{
			"<leader>od",
			"<cmd>Overleaf disconnect<cr>",
			desc = "Disconnect",
		},
		{
			"<leader>ow",
			"<cmd>Overleaf compile watch<cr>",
			desc = "Compile watch",
		},
		{
			"<leader>oW",
			"<cmd>Overleaf compile stop<cr>",
			desc = "Stop compile watch",
		},
		{
			"<leader>ou",
			":Overleaf upload ",
			desc = "Upload file [path]",
		},

		{ "<leader>oc", group = "Comments" },
		{
			"<leader>ocl",
			"<cmd>Overleaf comments<cr>",
			desc = "List",
		},
		{
			"<leader>oca",
			"<cmd>Overleaf comment add<cr>",
			mode = { "v" },
			desc = "Add",
		},
		{
			"<leader>ocg",
			"<cmd>Overleaf comment show<cr>",
			desc = "Go to thread",
		},
		{
			"<leader>ocr",
			"<cmd>Overleaf comment reply<cr>",
			desc = "Reply",
		},
		{
			"<leader>oct",
			"<cmd>Overleaf comment resolve<cr>",
			desc = "Close/reopen comment",
		},
		{
			"<leader>ocR",
			"<cmd>Overleaf comments refresh<cr>",
			desc = "Refresh",
		},
		{
			"<leader>och",
			"<cmd>Overleaf history<cr>",
			desc = "History",
		},

		{
			"<leader>oS",
			"<cmd>Overleaf sync<cr>",
			desc = "Sync",
		},
		{
			"<leader>oi",
			"<cmd>Overleaf sync import<cr>",
			desc = "Import",
		},
		{
			"<leader>oe",
			"<cmd>Overleaf sync export<cr>",
			desc = "Export",
		},
	})
end

function M.config()
	require("overleaf").setup({
		sync_dir = "~/.overleaf",
		explorer = "canola",
		compile = {
			backend = "local",
		},
	})
end

return M
