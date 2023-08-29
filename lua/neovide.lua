M = {}

function M.setup()
	vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h16"
	vim.g.neovide_padding_top = 50
	vim.g.neovide_padding_bottom = 50
	vim.g.neovide_padding_right = 50
	vim.g.neovide_padding_left = 50
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_refresh_rate = 120
end

return M
