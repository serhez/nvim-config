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
			"<leader>oe",
			"<cmd>Overleaf explorer<cr>",
			desc = "Explorer",
		},
		{
			"<leader>ob",
			"<cmd>Overleaf compile<cr>",
			desc = "Build saved files",
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
			"<leader>ocd",
			"<cmd>Overleaf comments drafts<cr>",
			desc = "Retained drafts",
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
			desc = "Rescan saved files",
		},

		{ "<leader>ox", group = "Conflicts / recovery" },
		{
			"<leader>oxl",
			"<cmd>Overleaf conflicts<cr>",
			desc = "List held files",
		},
		{
			"<leader>oxr",
			"<cmd>Overleaf resolve<cr>",
			desc = "Resolve current file",
		},
		{
			"<leader>oxc",
			"<cmd>Overleaf resolve codediff<cr>",
			desc = "Resolve with CodeDiff",
		},
		{
			"<leader>oxh",
			"<cmd>Overleaf resolve history<cr>",
			desc = "Resolve live undo",
		},
		{
			"<leader>oxH",
			"<cmd>Overleaf resolve disk-history<cr>",
			desc = "Resolve persistent undo",
		},
		{
			"<leader>oxe",
			"<cmd>Overleaf recover<cr>",
			desc = "Review recovery versions",
		},
		{
			"<leader>oxk",
			"<cmd>Overleaf recover locks<cr>",
			desc = "Review writer locks",
		},
	})
end

function M.config()
	require("overleaf").setup({
		node_path = "/opt/homebrew/bin/node",
		sync_dir = "~/.overleaf",
		explorer = "canola",
		picker = "auto",
		compile = {
			backend = "local",
			open_pdf = true,
			auto_start_watch = false,
		},
	})
end

return M
