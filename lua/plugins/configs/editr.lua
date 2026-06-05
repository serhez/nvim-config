local M = {
	"serhez/editr.nvim",
	dev = true,
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
	cmd = {
		"EditrInfo",
		"EditrRemoteFiles",
		"EditrRemoteGrep",
		"EditrCanola",
		"EditrOil",
		"EditrHydrate",
	},
	opts = {
		editr_bin = "editr",
		integrations = {
			snacks = true,
			canola = true,
			oil = true,
		},
		remote_open_policy = "auto_under_limit",
		max_auto_hydrate_size = "25 MB",
		hydration_mode = "live",
		flush_on_write = true,
	},
}

return M
