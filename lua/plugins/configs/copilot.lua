local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	-- enabled = false,
}

function M.init()
	require("mappings").register({
		{ "<leader>as", "<cmd>Copilot panel<cr>", desc = "Copilot suggestions" },
		{ "<leader>ac", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
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
				ratio = 0.33,
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
