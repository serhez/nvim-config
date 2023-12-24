local M = {}

function M.setup()
	vim.opt.guifont = "JetBrainsMono Nerd Font Mono Light:h16:#h-none:#e-subpixelantialias"
	vim.g.neovide_padding_top = 40
	vim.g.neovide_padding_bottom = 10
	vim.g.neovide_padding_right = 20
	vim.g.neovide_padding_left = 20
	vim.g.neovide_cursor_animation_length = 0.1
	vim.g.neovide_cursor_trail_size = 0.2
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_refresh_rate = 120
end

return M
