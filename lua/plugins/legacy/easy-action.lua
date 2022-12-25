-- TODO: Make this work or remove

local M = {
	"Weissle/easy-action",
	dependencies = { "kevinhwang91/promise-async" },
	-- event = "VeryLazy",
}

function M.config()
	local easy_action = require("easy-action")
	-- local opts = { silent = true, remap = false }

	easy_action.setup({
		jump_provider = "leap",
	})

	-- vim.keymap.set("n", "q", "<cmd>BasicEasyAction<cr>", opts)
	--
	-- -- To insert something and jump back after you leave the insert mode
	-- vim.keymap.set("n", "m", function()
	-- 	easy_action.base_easy_action("i", nil, "InsertLeave")
	-- end, opts)
end

return M
