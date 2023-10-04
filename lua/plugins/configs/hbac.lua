local M = {
	"axkirillov/hbac.nvim",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		B = {
			-- p = { "<cmd>lua require('hbac').toggle_pin()<cr>", "Toggle pin" }, -- This is defined in bufferline
			c = { "<cmd>lua require('hbac').close_unpinned()<cr>", "Close unpinned" },
		},
	})
end

function M.config()
	require("hbac").setup({
		autoclose = true, -- set autoclose to false if you want to close manually
		threshold = 6, -- hbac will start closing unedited buffers once that number is reached
		close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
	})
end

return M
