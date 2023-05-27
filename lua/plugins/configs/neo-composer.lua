local M = {
	"ecthelionvi/NeoComposer.nvim",
	dependencies = { "kkharji/sqlite.lua" },
	event = "BufRead",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		m = {
			name = "Macros",
			c = { "<cmd>ClearNeoComposer<cr>", "Clear" },
			d = { "<cmd>ToggleDelay<cr>", "Toggle delay" },
			m = { '<cmd>lua require("NeoComposer.ui").toggle_macro_menu()<cr>', "Menu" },
		},
	})
end

function M.config()
	require("NeoComposer").setup({
		notify = true,
		delay_timer = 150,
		keymaps = {
			play_macro = "Q",
			yank_macro = "yq",
			stop_macro = "cq",
			toggle_record = "q",
			cycle_next = "<c-q>",
			cycle_prev = "<nul>",
			toggle_macro_menu = "<c-m>",
		},
	})
end

return M
