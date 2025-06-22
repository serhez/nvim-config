local M = {
	"xzbdmw/clasp.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
}

-- NOTE: we do not want to use M-l/M-h because they clash with window navigation
--       A works the same as M in kitty (and most other terminals, because the
--       standard is Ctrl/Alt, so let's not use it so that it is compatible with linux too)
function M.config()
	require("clasp").setup({
		pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["$"] = "$" },
	})

	-- Jumping from smallest region to largest region
	vim.keymap.set({ "i" }, "<C-n>", function()
		require("clasp").wrap("next")
	end)

	-- Jumping from largest region to smallest region
	vim.keymap.set({ "i" }, "<C-p>", function()
		require("clasp").wrap("prev")
	end)
end

return M
