local mappings = require("mappings")

local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
}

function M.init()
	mappings.register_normal({
		a = {
			p = { "<cmd>Copilot panel<cr>", "Panel" },
			a = { "<cmd>Copilot attach<cr>", "Attach" },
			d = { "<cmd>Copilot detach<cr>", "Detach" },
			s = { "<cmd>Copilot status<cr>", "Status" },
			t = { "<cmd>Copilot toggle<cr>", "Toggle" },
		},
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
				accept = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
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
	})
end

return M
