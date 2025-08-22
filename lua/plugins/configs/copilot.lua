local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VeryLazy",
}

vim.g.copilot_loaded = false

function M.init()
	require("mappings").register({
		{ "<leader>ao", "<cmd>Copilot panel<cr>", desc = "Copilot options" },
		{ "<leader>at", "<cmd>Copilot toggle<cr>", desc = "Toggle copilot" },
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

	vim.g.copilot_loaded = true
end

return M
