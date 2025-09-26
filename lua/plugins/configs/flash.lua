local M = {
	"folke/flash.nvim",
	event = "BufRead",
}

function M.config()
	local flash = require("flash")
	flash.setup({
		search = {
			incremental = true,
		},
		modes = {
			search = {
				enabled = false,
			},
			char = {
				keys = { "f", "F" }, -- { "f", "F", "t", "T", ";", "," }
			},
		},
		label = {
			style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
			rainbow = {
				enabled = true,
				-- number between 1 and 9
				shade = 4,
			},
		},
	})

	vim.keymap.set({ "n", "x", "o" }, "f", function()
		flash.jump()
	end, { desc = "Jump to char" })
	vim.keymap.set({ "n", "x", "o" }, "F", function()
		flash.treesitter({
			actions = {
				["<c-.>"] = "next",
				["<c-,>"] = "prev",
			},
		})
	end, { desc = "Treesitter selection" })
	-- vim.keymap.set({ "o" }, "r", function()
	-- 	flash.remote()
	-- end, { desc = "Remote" })
	vim.keymap.set({ "o", "x" }, "r", function()
		flash.treesitter_search()
	end, { desc = "Remote" })
	-- vim.keymap.set({ "c" }, "<c-s>", function()
	-- 	flash.toggle()
	-- end, { desc = "Toggle flash search" })
end

return M
