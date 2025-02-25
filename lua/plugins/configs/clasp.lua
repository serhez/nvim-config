local M = {
	"xzbdmw/clasp.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
}

function M.config()
	require("clasp").setup({
		pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["$"] = "$" },
	})

	-- jumping from smallest region to largest region
	vim.keymap.set({ "i" }, "<c-l>", function()
		require("clasp").wrap("next")
	end)

	-- jumping from largest region to smallest region
	vim.keymap.set({ "i" }, "<c-h>", function()
		require("clasp").wrap("prev")
	end)
end

return M
