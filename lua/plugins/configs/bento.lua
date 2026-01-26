local M = {
	"serhez/bento.nvim",
	dev = true,
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
}

function M.config()
	require("bento").setup({
		max_open_buffers = 10,
		map_last_accessed = false,
	})

	local api = require("bento.api")

	-- Register menu keymaps
	api.register_expand_key(";")
	api.register_last_buffer_key(";")
	api.register_collapse_key("<Esc>")
	api.register_prev_page_key("[")
	api.register_next_page_key("]")

	-- Register actions
	api.register_action("open", {
		key = "<CR>",
		action = api.actions.open,
		hl = "DiagnosticVirtualTextHint",
	})
	api.register_action("delete", {
		key = "<BS>",
		action = api.actions.delete,
		hl = "DiagnosticVirtualTextError",
	})
	api.register_action("vsplit", {
		key = "|",
		action = api.actions.vsplit,
		hl = "DiagnosticVirtualTextInfo",
	})
	api.register_action("split", {
		key = "_",
		action = api.actions.split,
		hl = "DiagnosticVirtualTextInfo",
	})
	api.register_action("lock", {
		key = "*",
		action = api.actions.lock,
		hl = "DiagnosticVirtualTextWarn",
	})

	-- Set default action
	api.set_default_action("open")
end

return M
