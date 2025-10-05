local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	-- requires = {
	-- 	"copilotlsp-nvim/copilot-lsp", -- for NES functionality
	-- },
	-- event = "VeryLazy",
	event = "InsertEnter",
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
				position = "bottom",
				ratio = 0.33,
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = false,
			keymap = {
				accept = "<C-l>",
				next = "<C-j>",
				prev = "<C-k>",
				dismiss = "<C-h>",
			},
		},
		nes = {
			-- BUG: using folke's sidekick.nvim instead
			enabled = false, -- requires copilot-lsp as a dependency
			auto_trigger = true,
			keymap = {
				accept_and_goto = "<C-CR>",
				accept = "<C-g>",
				dismiss = false,
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
		-- logger = {
		-- 	file_log_level = vim.log.levels.TRACE,
		-- 	print_log_level = vim.log.levels.TRACE,
		-- 	trace_lsp = "verbose",
		-- 	log_lsp_messages = true,
		-- 	trace_lsp_progress = true,
		-- },

		server_opts_overrides = {
			autostart = true,
		},
	})

	vim.g.copilot_loaded = true
end

return M
