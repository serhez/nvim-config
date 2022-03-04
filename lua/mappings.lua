-- Leader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- Better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- Terminal window navigation
vim.cmd([[
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
  inoremap <C-h> <C-\><C-N><C-w>h
  inoremap <C-j> <C-\><C-N><C-w>j
  inoremap <C-k> <C-\><C-N><C-w>k
  inoremap <C-l> <C-\><C-N><C-w>l
  tnoremap <Esc> <C-\><C-n>
]])

-- Resize with arrows
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize +2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', {silent = true})

-- Better indenting
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- Tab switch buffer
vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprevious<CR>', {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv-gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv-gv', {noremap = true, silent = true})

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')
-- vim.cmd('inoremap <expr> <TAB> (\"\\<C-n>\")')
-- vim.cmd('inoremap <expr> <S-TAB> (\"\\<C-p>\")')

-- Incrementing and decrementing
vim.cmd'set nrformats='
vim.api.nvim_set_keymap('n', '+', '<C-a>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '-', '<C-x>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '+', 'g<C-a>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '-', 'g<C-x>', {noremap = true, silent = true})

-- Respect wrapping with jk navigation
vim.cmd"nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'"
vim.cmd"nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'"

-- Switch to previous buffer with backspace
vim.api.nvim_set_keymap('n', '<Backspace>', '<C-^>', {noremap = true, silent = true})

-- Always center the cursor
vim.api.nvim_set_keymap('n', '{', '{zz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '}', '}zz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'n', 'nzz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ']c', ']czz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[c', '[czz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ']j', ']jzz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[j', '[jzz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ']s', ']szz', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[s', '[szz', {noremap = true, silent = true})

-- Make . work over visual selections
vim.api.nvim_set_keymap('x', '.', ':norm.<CR>', {noremap = true, silent = true})

-- Avoid c storing in registers
vim.api.nvim_set_keymap('n', 'c', '"_c', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'C', '"_C', {noremap = true, silent = true})

-- Sensible clipboard paste in insert mode
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>*', {noremap = true, silent = true})

-- Y behaves like D and C
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true, silent = true})

-- FIX: Remap to_lower() and let gu be used for go_to_usages()
-- vim.api.nvim_set_keymap("n", "gl", "gu", {noremap = false, silent = true})
-- vim.api.nvim_set_keymap("n", "gu", "<Nop>", {noremap = true, silent = true})

