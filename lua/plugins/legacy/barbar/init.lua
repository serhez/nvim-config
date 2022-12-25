vim.api.nvim_set_keymap("n", "<TAB>", ":BufferNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-TAB>", ":BufferPrevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-TAB>", ":BufferMoveNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-TAB>", ":BufferMovePrevious<CR>", { noremap = true, silent = true })

-- Enable/disable animations
vim.cmd("let bufferline.animation = v:true")

-- Enable/disable auto-hiding the tab bar when there is a single buffer
vim.cmd("let bufferline.auto_hide = v:false")

-- Enable/disable current/total tabpages indicator (top right corner)
vim.cmd("let bufferline.tabpages = v:true")

-- Enable/disable close button
vim.cmd("let bufferline.closable = v:true")

-- Enables/disable clickable tabs
--  - left-click: go to buffer
--  - middle-click: delete buffer
vim.cmd("let bufferline.clickable = v:true")

-- Enable/disable icons
-- if set to 'numbers', will show buffer index in the tabline
-- if set to 'both', will show buffer index and icons in the tabline
vim.cmd("let bufferline.icons = v:true")

-- Sets the icon's highlight group.
-- If v:false, will use nvim.cmd('let web-devicons colors')
vim.cmd("let bufferline.icon_custom_colors = v:false")

-- Configure icons on the bufferline.
vim.cmd('let bufferline.icon_separator_active = "▎"')
vim.cmd('let bufferline.icon_separator_inactive = "▎"')
vim.cmd('let bufferline.icon_close_tab = ""')
vim.cmd('let bufferline.icon_close_tab_modified = "●"')

-- Sets the maximum padding width with which to surround each tab.
vim.cmd("let bufferline.maximum_padding = 4")

-- Sets the maximum buffer name length.
vim.cmd("let bufferline.maximum_length = 30")

-- If set, the letters for each buffer in buffer-pick mode will be
-- assigned based on their name. Otherwise or in case all letters are
-- already assigned, the behavior is to assign letters in order of
-- usability (see order below)
vim.cmd("let bufferline.semantic_letters = v:false")

-- New buffer letters are assigned in this order. This order is
-- optimal for the qwerty keyboard layout but might need adjustement
-- for other layouts.
vim.cmd('let bufferline.letters = "asdfjklghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP"')

-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
-- where X is the buffer number. But only a static string is accepted here.
vim.cmd('let bufferline.no_name_title = ""')
