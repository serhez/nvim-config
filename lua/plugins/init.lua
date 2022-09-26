local present, packer = pcall(require, "plugins.packerInit")

if not present then
	return false
end

-- Auto compile when there are changes in plugins.lua
vim.cmd("autocmd BufWritePost plugins/init.lua PackerCompile")

-- Disable built-in plugins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit",
}
for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

local plugins = {

	-- Core

	{ "nvim-lua/plenary.nvim" },

	{ "lewis6991/impatient.nvim" },

	{ "nathom/filetype.nvim" },

	{
		"wbthomason/packer.nvim",
		event = "VimEnter",
	},

	{
		"kyazdani42/nvim-web-devicons",
	},

	{
		"feline-nvim/feline.nvim",
		after = "nvim-web-devicons",
		config = "require('plugins.configs.feline')",
	},

	{
		"akinsho/bufferline.nvim",
		after = "nvim-web-devicons",
		config = "require('plugins.configs.bufferline')",
	},

	{
		"famiu/bufdelete.nvim",
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},

	-- Installers

	{
		"williamboman/mason.nvim",
		config = "require('plugins.configs.installer.mason')",
	},

	{
		"williamboman/mason-lspconfig.nvim",
		requires = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		after = "mason.nvim",
		config = "require('plugins.configs.installer.mason-lspconfig')",
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = "require('plugins.configs.installer.mason-tool-installer')",
	},

	-- Treesitter

	{
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		config = "require('plugins.configs.treesitter.treesitter')",
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		requires = "nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
	},

	{
		"windwp/nvim-ts-autotag",
		requires = "nvim-treesitter/nvim-treesitter",
		config = "require('plugins.configs.treesitter.autotag')",
		event = "BufReadPost",
	},

	{
		"RRethy/nvim-treesitter-textsubjects",
		requires = "nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufReadPost",
	},

	{
		"m-demare/hlargs.nvim",
		requires = { "nvim-treesitter/nvim-treesitter" },
		config = "require('plugins.configs.treesitter.hlargs')",
	},

	-- Git

	{
		"lewis6991/gitsigns.nvim",
		config = "require('plugins.configs.git.signs')",
	},

	{
		"tpope/vim-fugitive",
		event = "BufRead",
	},

	{
		"rhysd/git-messenger.vim",
		config = "require('plugins.configs.git.messenger')",
		cmd = "GitMessenger",
	},

	{
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = "require('plugins.configs.git.diffview')",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewToggleFiles" },
	},

	-- LSP

	{
		"neovim/nvim-lspconfig",
		module = "lspconfig",
		config = "require('plugins.configs.lsp.config')",
	},

	{
		"RRethy/vim-illuminate",
		config = "require('plugins.configs.lsp.illuminate')",
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = "require('plugins.configs.lsp.null-ls')",
		requires = { "nvim-lua/plenary.nvim" },
	},

	{
		"ray-x/lsp_signature.nvim",
		after = "nvim-lspconfig",
		config = "require('plugins.configs.lsp.signature')",
	},

	{
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
	},

	{
		"smjonas/inc-rename.nvim",
		config = "require('plugins.configs.lsp.inc-rename')",
	},

	-- Completion

	{
		"rafamadriz/friendly-snippets",
		module = "cmp_nvim_lsp",
		event = { "InsertEnter", "CmdlineEnter" },
	},

	{
		"hrsh7th/nvim-cmp",
		after = "friendly-snippets",
		config = "require('plugins.configs.completion.cmp')",
	},

	{
		"L3MON4D3/LuaSnip",
		wants = "friendly-snippets",
		after = "nvim-cmp",
		config = "require('plugins.configs.completion.luasnip')",
	},

	{
		"saadparwaiz1/cmp_luasnip",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"hrsh7th/cmp-nvim-lsp",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"hrsh7th/cmp-buffer",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"hrsh7th/cmp-path",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
		config = "require('plugins.configs.completion.cmp.tabnine')",
	},

	{
		"rcarriga/cmp-dap",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"hrsh7th/cmp-cmdline",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"dmitmel/cmp-cmdline-history",
		requires = "hrsh7th/nvim-cmp",
		after = "nvim-cmp",
	},

	{
		"petertriho/cmp-git",
		requires = "nvim-lua/plenary.nvim",
		after = "nvim-cmp",
		config = "require('plugins.configs.completion.cmp.git')",
	},

	-- Motions

	{
		"numToStr/Comment.nvim",
		module = "Comment",
		keys = { "gcc" },
		config = "require('plugins.configs.motions.comment')",
	},

	{
		"ggandor/lightspeed.nvim",
		config = "require('plugins.configs.motions.lightspeed')",
		event = "BufRead",
	},

	{
		"andymass/vim-matchup",
		config = "require('plugins.configs.motions.matchup')",
		event = "BufRead",
	},

	{
		"Jorengarenar/vim-MvVis",
		event = "BufRead",
	},

	{
		"tommcdo/vim-exchange",
		event = "BufRead",
	},

	{
		"stsewd/gx-extended.vim",
		event = "BufRead",
	},

	{
		"tpope/vim-repeat",
		event = "BufRead",
	},

	{
		"vim-scripts/visualrepeat",
		event = "BufRead",
	},

	{
		"chaoren/vim-wordmotion",
		event = "BufRead",
	},

	{
		"sickill/vim-pasta",
		event = "BufRead",
	},

	{
		"nacro90/numb.nvim",
		config = "require('plugins.configs.motions.numb')",
		event = "BufRead",
	},

	{
		"kylechui/nvim-surround",
		config = "require('plugins.configs.motions.surround')",
		event = "BufRead",
	},

	-- Sessions

	{
		"rmagatti/auto-session",
		config = "require('plugins.configs.session.auto-session')",
	},

	{
		"rmagatti/session-lens",
		requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
		config = "require('plugins.configs.session.session-lens')",
	},

	-- Remote

	{
		"chipsenkbeil/distant.nvim",
		config = "require('plugins.configs.remote.distant')",
		cmd = "DistantLaunch",
		run = ":DistantInstall",
	},

	-- Navigation, searching and finding

	{
		"kyazdani42/nvim-tree.lua",
		after = "nvim-web-devicons",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = "require('plugins.configs.tree')",
	},

	{
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = "require('plugins.configs.telescope')",
	},

	{
		"ahmedkhalf/project.nvim",
		after = "telescope.nvim",
		event = "BufRead",
		config = "require('plugins.configs.project')",
	},

	{
		"folke/which-key.nvim",
		config = "require('plugins.configs.which-key')",
	},

	{
		"windwp/nvim-spectre",
		config = "require('plugins.configs.spectre')",
		event = "BufRead",
		cmd = "Spectre",
	},

	{
		"folke/trouble.nvim",
		config = "require('plugins.configs.trouble')",
		cmd = "TroubleToggle",
	},

	{
		"kevinhwang91/nvim-hlslens",
		event = "BufRead",
	},

	{
		"folke/todo-comments.nvim",
		config = "require('plugins.configs.todo-comments')",
		event = "BufRead",
	},

	{
		"MattesGroeger/vim-bookmarks",
		cmd = {
			"BookmarkToggle",
			"BookmarkAnnotate",
			"BookmarkNext",
			"BookmarkPrev",
			"BookmarkShowAll",
			"BookmarkClear",
			"BookmarkClearAll",
		},
	},

	{
		"rmagatti/goto-preview",
		config = "require('plugins.configs.goto-preview')",
	},

	-- Testing

	{
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"haydenmeade/neotest-jest",
			"nvim-neotest/neotest-python",
		},
		config = "require('plugins.configs.testing.neotest')",
	},

	{
		"andythigpen/nvim-coverage",
		requires = "nvim-lua/plenary.nvim",
		config = "require('plugins.configs.testing.coverage')",
	},

	-- Debugging

	{
		"mfussenegger/nvim-dap",
		config = "require('plugins.configs.debugging.dap')",
	},

	{
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = "require('plugins.configs.debugging.ui')",
		-- cmd = { "DapContinue", "DapTest" },
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		requires = { "mfussenegger/nvim-dap" },
		config = "require('plugins.configs.debugging.virtual-text')",
		-- cmd = { "DapContinue", "DapTest" },
	},

	{
		"leoluz/nvim-dap-go",
		requires = { "mfussenegger/nvim-dap" },
		config = "require('plugins.configs.debugging.go')",
		-- cmd = { "DapContinue", "DapTest" },
	},

	{
		"mfussenegger/nvim-dap-python",
		requires = { "mfussenegger/nvim-dap" },
		config = "require('plugins.configs.debugging.python')",
		-- cmd = { "DapContinue", "DapTest" },
	},

	-- Refactoring

	{
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		after = "telescope.nvim",
		config = "require('plugins.configs.refactoring')",
	},

	-- Notebooks & Jupyter

	{
		"goerz/jupytext.vim",
		fp = "ipynb",
		config = "require('plugins.configs.notebooks.jupytext')",
	},

	{
		"dccsillag/magma-nvim",
		run = ":UpdateRemotePlugins",
		fp = "ipynb",
		config = "require('plugins.configs.notebooks.magma')",
	},

	--  Misc

	{
		"windwp/nvim-autopairs",
		config = "require('plugins.configs.autopairs')",
		event = "BufRead",
	},

	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = "require('plugins.configs.bqf')",
	},

	{
		"https://github.com/kevinhwang91/nvim-ufo",
		requires = "kevinhwang91/promise-async",
		config = "require('plugins.configs.ufo')",
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = "require('plugins.configs.indent-blankline')",
	},

	{
		"aserowy/tmux.nvim",
		config = "require('plugins.configs.tmux')",
	},

	{
		"NvChad/nvim-colorizer.lua",
		config = "require('plugins.configs.colorizer')",
		event = "BufRead",
	},

	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		ft = { "markdown", "rmd" },
		config = "require('plugins.configs.markdown-preview')",
		cmd = "MarkdownPreviewToggle",
	},

	{
		"kkoomen/vim-doge",
		run = ":call doge#install()",
		config = "require('plugins.configs.doge')",
		cmd = "DogeGenerate",
	},

	{
		"michaelb/sniprun",
		run = "bash install.sh",
		config = "require('plugins.configs.sniprun')",
		cmd = "SnipRun",
	},

	-- Colorschemes

	{
		"Shatur/neovim-ayu",
		config = "require('plugins.configs.colorschemes.ayu')",
	},

	{
		"rose-pine/neovim",
		as = "rose-pine",
		tag = "v1.*",
		config = "require('plugins.configs.colorschemes.rose-pine')",
	},

	{
		"catppuccin/nvim",
		as = "catppuccin",
		run = ":CatppuccinCompile",
		config = "require('plugins.configs.colorschemes.catppuccin')",
	},

	{ "projekt0n/github-nvim-theme" },

	{ "folke/tokyonight.nvim" },

	{ "joshdick/onedark.vim" },

	{ "shaunsingh/nord.nvim" },

	{ "ishan9299/nvim-solarized-lua" },

	{ "dracula/vim", as = "dracula" },

	{ "haishanh/night-owl.vim" },

	{ "whatyouhide/vim-gotham" },

	{ "morhetz/gruvbox" },

	{ "drewtempelmeyer/palenight.vim" },

	-- Helpers

	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	},
}

return packer.startup({
	plugins,
	config = {
		max_jobs = 5,
	},
})

-- To watch

-- Replacement for gitsigns: https://github.com/tanvirtin/vgit.nvim
-- Search jupyter integration plugins
-- Follow links in markdown: https://github.com/jakewvincent/mkdnflow.nvim
-- Complete jupyter plugin (author abandoned it in alpha stage): https://github.com/ahmedkhalf/jupyter-nvim
-- DoGe vs Neogen (https://github.com/danymat/neogen)

-- Legacy

-- {
--     "kabouzeid/nvim-lspinstall",
--     config = "require('plugins.configs.lspinstall')",
-- },

-- {
--    "glepnir/dashboard-nvim",
--    config = "require('plugins.configs.dashboard')",
-- },

-- {
--     "rmagatti/auto-session",
--     config = "require('plugins.configs.auto-session')",
-- },

-- {
--     "tpope/vim-rhubarb",
--     event = "BufRead",
-- },

-- {
--     "mattn/vim-gist",
--     requires = {"mattn/webapi-vim"},
--     config = "require('plugins.configs.gist')",
--     cmd = "Gist",
-- },

-- {
--     "junegunn/gv.vim",
--     cmd = "GV",
-- },

-- {
--     "turbio/bracey.vim",
--     cmd = "Bracey",
-- },

-- {
--     "gelguy/wilder.nvim",
--     run = ":UpdateRemotePlugins",
--     config = "require('plugins.configs.wilder')",
-- },

-- {
--     "akinsho/toggleterm.nvim",
--     config = "require('plugins.configs.toggleterm')",
-- },

-- {
--     "markonm/traces.vim",
--     event = "BufRead",
-- },

-- {
--     "haya14busa/is.vim",
--     event = "BufRead",
-- },

-- {
--     "kshenoy/vim-signature",
--     event = "BufRead",
-- },

-- {
--     "goerz/jupytext.vim",
--     ft = "ipynb",
-- },

-- {
--     "christoomey/vim-tmux-navigator",
-- },

-- {
--     "tmux-plugins/vim-tmux-focus-events",
-- },

-- {
--     "roxma/vim-tmux-clipboard",
-- },

-- {
--     "tpope/vim-obsession",
-- },

-- {
--     "romgrk/nvim-treesitter-context",
--     requires = "nvim-treesitter/nvim-treesitter",
--     config = "require('plugins.configs.treesitter.context')",
--     event = "BufRead",
-- },

-- {
--     "nvim-lualine/lualine.nvim",
--     after = {"nvim-web-devicons", "nvim-gps"},
--     config = "require('plugins.configs.lualine')",
-- },

-- {
--     "sbdchd/neoformat",
--     config = "require('plugins.configs.neoformat')",
--     cmd = "Neoformat",
-- },

-- {
--     "folke/zen-mode.nvim",
--     cmd = "ZenMode",
--     config = "require('plugins.configs.zen-mode')",
-- },

-- {
--     "dstein64/nvim-scrollview",
--     branch = "main",
--     config = "require('plugins.configs.scrollview')",
--     cmd = {"ScrollViewEnable", "ScrollViewDisable", "ScrollViewRefresh"}
-- },

-- {
--     "ethanholz/nvim-lastplace",
--     config = "require('plugins.configs.lastplace')",
-- },

-- {
-- 	"anuvyklack/pretty-fold.nvim",
-- 	config = "require('plugins.configs.pretty-fold')",
-- },

-- {
-- 	"SmiteshP/nvim-gps",
-- 	requires = "nvim-treesitter/nvim-treesitter",
-- 	after = "nvim-treesitter",
-- 	config = "require('plugins.configs.gps')",
-- },

-- {
--     "tami5/lspsaga.nvim",
--     config = "require('plugins.configs.lsp.saga')",
-- },

-- {
--     "folke/lsp-colors.nvim",
--     event = "BufRead",
-- },

-- {
--     "akinsho/git-conflict.nvim",
--     config = "require('plugins.configs.git.conflict')",
--     event = "BufRead",
-- },

-- {
--     "SmiteshP/nvim-navic",
--     requires = "neovim/nvim-lspconfig",
--     config = "require('plugins.configs.navic')",
-- },

-- {
--     "ahmedkhalf/jupyter-nvim",
--     run = ":UpdateRemotePlugins",
--     config = "require('plugins.configs.notebooks.jupyter')",
-- },

-- {
--     "metakirby5/codi.vim",
--     config = "require('plugins.configs.codi')",
--     cmd = "Codi",
-- },

-- {
--     "ahonn/vim-fileheader",
--     config = "require('plugins.configs.fileheader')",
--     cmd = { "AddFileHeader", "UpdateFileHeader" },
-- },

-- {
--     "liuchengxu/vista.vim",
--     cmd = "Vista",
--     config = "require('plugins.configs.vista')",
-- },

-- {
--     "mrshmllow/document-color.nvim",
--     config = "require('plugins.configs.document-color')",
--     -- event = "BufRead",
-- },
