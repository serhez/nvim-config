local M = {
	"serhez/tabern.nvim",
	dev = true,
	lazy = false,
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

local function rename_current_tab()
	local tabern = require("tabern")
	vim.ui.input({
		prompt = "Tab name: ",
		default = tabern.get_name(),
	}, function(name)
		if name == nil then
			return
		end

		if name == "" then
			tabern.clear_name()
		else
			tabern.set_name(name)
		end
	end)
end

function M.init()
	require("mappings").register({
		"<leader>tr",
		rename_current_tab,
		desc = "Rename current tab",
	})
end

return M
