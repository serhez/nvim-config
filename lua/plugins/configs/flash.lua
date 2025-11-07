local M = {
	"folke/flash.nvim",
	event = "BufRead",
}

function M.config()
	local flash = require("flash")
	flash.setup({
		search = {
			-- BUG: Do NOT enable this, as it breaks the search algorithm
			--      when only one match exists in the viewport & it allows
			--      jumping to lines outside of the viewport.
			-- incremental = true,
		},
		modes = {
			search = {
				enabled = false,
			},
			char = {
				keys = { "f", "t" },
			},
		},
		jump = {
			autojump = true,
		},
		label = {
			style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
			rainbow = {
				enabled = true,
				shade = 4, -- number between 1 and 9
			},
		},
	})

	vim.keymap.set({ "n", "x", "o" }, "f", function()
		flash.jump()
	end, { desc = "Jump to char" })
	vim.keymap.set({ "n", "v", "x", "o" }, "t", function()
		flash.treesitter({
			actions = {
				["<c-.>"] = "next",
				["<c-,>"] = "prev",
			},
		})
	end, { desc = "Treesitter selection" })
	vim.keymap.set({ "o", "x" }, "r", function()
		flash.treesitter_search()
	end, { desc = "Remote" })
end

return M
