-- Ultra-light neovim config for big files
-- Used by bigfile.lua when opening large files in tmux pane

-- Load teide colorscheme from dev path
vim.opt.runtimepath:prepend("~/dev/teide.nvim")
pcall(function()
	require("teide").setup({ plugins = { auto = false } })
	require("teide").load()
end)

-- Disable ALL built-in plugins before anything loads
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_man = 1
vim.g.loaded_remote_plugins = 1

-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable all the heavy stuff
vim.opt.loadplugins = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.undolevels = -1
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.shadafile = "NONE"

-- Disable syntax and filetype detection
vim.cmd("syntax off")
vim.cmd("filetype off")
vim.opt.syntax = "off"

-- Performance options
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 0
vim.opt.redrawtime = 0
vim.opt.regexpengine = 1 -- Old engine, sometimes faster for simple patterns
vim.opt.maxmempattern = 1000

-- Disable folding entirely
vim.opt.foldmethod = "manual"
vim.opt.foldenable = false
vim.opt.foldlevel = 999

-- Line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true -- Wrap at word boundaries
vim.opt.breakindent = true -- Preserve indentation in wrapped lines

-- Minimal UI
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.signcolumn = "no"
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.colorcolumn = ""
vim.opt.list = false
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""

-- No statusline/tabline
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.opt.winbar = ""

-- Disable modeline parsing (security + performance)
vim.opt.modeline = false
vim.opt.modelines = 0

-- Disable intro and other messages
vim.opt.shortmess = "aoOtTIcF"

-- Disable spell
vim.opt.spell = false

-- Minimal completion
vim.opt.complete = ""
vim.opt.completeopt = ""

-- Disable matching parens
vim.opt.showmatch = false
vim.opt.matchtime = 0

-- Basic usability
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false -- Keep off by default

-- Faster update
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- Long line / unicode optimizations
vim.opt.display = "lastline,uhex" -- Show partial long lines, hex for unprintable
vim.opt.ambiwidth = "single" -- Treat ambiguous width chars as single (faster)

-- Disable features that scan the buffer
vim.opt.tagbsearch = false
vim.opt.tagcase = "ignore"
vim.opt.showmatch = false
vim.opt.matchpairs = "" -- Don't even look for matching pairs

-- Simple visual feedback for position
vim.keymap.set("n", "<C-g>", function()
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	local total = vim.fn.line("$")
	print(string.format(" %d:%d / %d lines ", line, col, total))
end)
