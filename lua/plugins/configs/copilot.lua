local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VeryLazy",
}

function M.init()
	require("mappings").register({
		{ "<leader>ap", "<cmd>Copilot panel<cr>", desc = "Copilot panel" },
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
				refresh = "r",
				open = "<C-o>",
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
				accept = "<C-l>",
				next = "<C-j>",
				prev = "<C-k>",
				dismiss = "<C-h>",
			},
		},
		filetypes = {
			yaml = true,
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
		logger = {
			print_log_level = vim.log.levels.OFF, -- disable annoying messages when no internet
		},
		server_opts_overrides = {
			autostart = true,
		},
	})
end

return M
