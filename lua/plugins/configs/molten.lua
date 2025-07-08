local M = {
	"benlubas/molten-nvim",
	dependencies = {
		-- "3rd/image.nvim",
		-- "willothy/wezterm.nvim",
	},
	build = ":UpdateRemotePlugins",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	-- vim.g.molten_image_provider = "wezterm"
	-- vim.g.molten_image_provider = "image.nvim"
	vim.g.molten_image_provider = "none"
	vim.g.molten_output_win_max_height = 20
	vim.g.molten_auto_open_output = false
	vim.g.molten_output_crop_border = true
	vim.g.molten_output_win_border = { "", "━", "", "" }
	vim.g.molten_virt_text_output = true
	vim.g.molten_use_border_highlights = true
	vim.g.molten_virt_lines_off_by_1 = true
	vim.g.molten_wrap_output = true

	-- Set the kernel variable for the statusline
	-- vim.api.nvim_create_autocmd({ "MoltenInitPost" }, {
	-- 	callback = function()
	-- 		require("plugins.configs.feline").set_kernel(require("molten.status").kernels())
	-- 	end,
	-- })
	-- vim.api.nvim_create_autocmd({ "MoltenDeinitPost" }, {
	-- 	callback = function()
	-- 		require("plugins.configs.feline").set_kernel(nil)
	-- 	end,
	-- })
end

return M
