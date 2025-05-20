local M = {
	"caliguIa/zendiagram.nvim",
}

function M.init()
	local zendiagram = require("zendiagram")

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		callback = function()
			zendiagram.open({ focus = false })
		end,
	})

	vim.diagnostic.open_float = zendiagram.open

	vim.keymap.set({ "n", "x" }, "]e", function()
		vim.diagnostic.jump({ count = 1 })
		vim.schedule(function()
			zendiagram.open()
		end)
	end, { desc = "Jump to next diagnostic" })

	vim.keymap.set({ "n", "x" }, "[e", function()
		vim.diagnostic.jump({ count = -1 })
		vim.schedule(function()
			zendiagram.open()
		end)
	end, { desc = "Jump to prev diagnostic" })
end

function M.config()
	require("zendiagram").setup({
		header = "Diagnostics", -- Float window title
		source = true, -- Whether to display diagnostic source
		relative = "win", -- "line"|"win" - What the float window's position is relative to
		anchor = "NE", -- "NE"|"SE"|"SW"|"NW" - When 'relative' is set to "win" this sets the position of the floating window
		-- max_width = 50, -- The maximum width of the float window
		-- min_width = 25, -- The minimum width of the float window
		-- max_height = 20, -- The maximum height of the float window
		-- border = "none", -- The border style of the float window
		-- position = {
		-- 	row = 1, -- The offset from the top of the screen
		-- 	col_offset = 0, -- The offset from the right of the screen
		-- },
	})
end

return M
