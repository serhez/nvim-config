local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
}

function M.init()
	require("mappings").register({
		{ "<leader>ap", "<cmd>Copilot panel<cr>", desc = "Panel" },
		{ "<leader>aa", "<cmd>Copilot attach<cr>", desc = "Attach" },
		{ "<leader>ad", "<cmd>Copilot detach<cr>", desc = "Detach" },
		{ "<leader>as", "<cmd>Copilot status<cr>", desc = "Status" },
		{ "<leader>at", "<cmd>Copilot toggle<cr>", desc = "Toggle" },
	})
end

function M.config()
	require("copilot").setup({
		panel = {
			enabled = true,
			auto_refresh = true,
			keymap = {
				jump_prev = "[[",
				jump_next = "]]",
				accept = "<CR>",
				refresh = "R",
				open = "<M-c>",
			},
			layout = {
				position = "right",
				ratio = 0.3,
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<D-l>",
				next = "<M-j>",
				prev = "<M-k>",
				dismiss = "<M-h>",
			},
		},
		filetypes = {
			yaml = true,
			markdown = true,
			help = false,
			gitcommit = true,
			gitrebase = true,
			hgcommit = true,
			svn = true,
			cvs = true,
			["."] = false,
		},
		server_opts_overrides = {
			autostart = true,
		},
	})
end

return M
