local M = {
	"mbbill/undotree",
	cmd = "UndotreeToggle",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	require("mappings").register_normal({
		u = { "<cmd>UndotreeToggle<cr>", "Undo tree" },
	})
end

return M
