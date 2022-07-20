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
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig",
        config = "require('plugins.configs.navic')",
    },

    {
        "feline-nvim/feline.nvim",
        after = "nvim-web-devicons",
        config = "require('plugins.configs.feline')",
    },

    {
        "b0o/incline.nvim",
        config = "require('plugins.configs.incline')",
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

    -- Treesitter

    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        config = "require('plugins.configs.treesitter')",
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
    },

    {
        "windwp/nvim-ts-autotag",
        requires = "nvim-treesitter/nvim-treesitter",
        config = "require('plugins.configs.treesitter-autotag')",
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
        config = "require('plugins.configs.hlargs')",
    },

    -- Git

    {
        "lewis6991/gitsigns.nvim",
        opt = true,
        config = "require('plugins.configs.gitsigns')",
        setup = function()
            require("utils").packer_lazy_load("gitsigns.nvim")
        end,
    },

    {
        "tpope/vim-fugitive",
        event = "BufRead",
    },

    {
        "rhysd/git-messenger.vim",
        config = "require('plugins.configs.git-messenger')",
        cmd = "GitMessenger",
    },

    {
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = "require('plugins.configs.diffview')",
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewToggleFiles" },
    },

    {
        "akinsho/git-conflict.nvim",
        config = "require('plugins.configs.git-conflict')",
        event = "BufRead",
    },

    -- LSP

    {
        "neovim/nvim-lspconfig",
        module = "lspconfig",
        setup = function()
            require("utils").packer_lazy_load("nvim-lspconfig")
            -- reload the current file so lsp actually starts for it
            vim.defer_fn(function()
                vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
            end, 0)
        end,
        config = "require('plugins.configs.lspconfig')",
    },

    {
        "RRethy/vim-illuminate",
        config = "require('plugins.configs.illuminate')",
    },

    {
        "williamboman/nvim-lsp-installer",
        requires = "neovim/nvim-lspconfig",
        config = "require('plugins.configs.lsp-installer')",
        event = "BufRead",
        -- cmd = {
        --     "LspInstallInfo",
        --     "LspInstall",
        --     "LspUninstall",
        --     "LspUninstallAll",
        --     "LspInstallLog",
        --     "LspPrintInstalled",
        -- },
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        config = "require('lsp.null-ls')",
        requires = { "nvim-lua/plenary.nvim" },
    },

    {
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = "require('plugins.configs.lsp_signature')",
    },

    {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
    },

    {
        "tami5/lspsaga.nvim",
        config = "require('plugins.configs.lspsaga')",
    },

    -- Completion

    {
        "rafamadriz/friendly-snippets",
        module = "cmp_nvim_lsp",
        event = "InsertEnter",
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        after = "friendly-snippets",
        config = "require('plugins.configs.cmp')",
    },

    {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        after = "nvim-cmp",
        config = "require('plugins.configs.luasnip')",
    },

    {
        "saadparwaiz1/cmp_luasnip",
        requires = "hrsh7th/nvim-cmp",
        after = "LuaSnip",
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        requires = "hrsh7th/nvim-cmp",
        after = "cmp_luasnip",
    },

    {
        "hrsh7th/cmp-buffer",
        requires = "hrsh7th/nvim-cmp",
        after = "cmp-nvim-lsp",
    },

    {
        "hrsh7th/cmp-path",
        requires = "hrsh7th/nvim-cmp",
        after = "cmp-buffer",
    },

    {
        "tzachar/cmp-tabnine",
        run = "./install.sh",
        requires = "hrsh7th/nvim-cmp",
        after = "cmp-path",
        config = "require('plugins.configs.cmp.tabnine')",
    },

    {
        "rcarriga/cmp-dap",
        requires = "hrsh7th/nvim-cmp",
        after = "cmp-tabnine",
    },

    {
        "hrsh7th/cmp-cmdline",
        requires = "hrsh7th/nvim-cmp",
        after = "cmp-dap",
    },

    {
        "petertriho/cmp-git",
        requires = "nvim-lua/plenary.nvim",
        after = "cmp-cmdline",
        config = "require('plugins.configs.cmp-git')",
    },

    -- Motions

    {
        "numToStr/Comment.nvim",
        module = "Comment",
        keys = { "gcc" },
        config = "require('plugins.configs.comment')",
    },

    {
        "ggandor/lightspeed.nvim",
        config = "require('plugins.configs.lightspeed')",
        event = "BufRead",
    },

    {
        "andymass/vim-matchup",
        config = "require('plugins.configs.matchup')",
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
        config = "require('plugins.configs.numb')",
        event = "BufRead",
    },

    -- Sessions

    {
        "rmagatti/auto-session",
        config = "require('plugins.configs.auto-session')",
    },

    {
        "rmagatti/session-lens",
        requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
        config = "require('plugins.configs.session-lens')",
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
        "norcalli/nvim-colorizer.lua",
        config = "require('plugins.configs.colorizer')",
        event = "BufRead",
    },

    {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
        ft = "markdown",
        config = "require('plugins.configs.markdown-preview')",
        cmd = "MarkdownPreviewToggle",
    },

    {
        "metakirby5/codi.vim",
        config = "require('plugins.configs.codi')",
        cmd = "Codi",
    },

    {
        "ahonn/vim-fileheader",
        config = "require('plugins.configs.fileheader')",
        cmd = { "AddFileHeader", "UpdateFileHeader" },
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
        -- cmd = "lua require('spectre').open()", -- TODO: Lazy loading on cmd
    },

    {
        "liuchengxu/vista.vim",
        cmd = "Vista",
        config = "require('plugins.configs.vista')",
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
        config = "require('plugins.configs.test.neotest')",
    },

    {
        "andythigpen/nvim-coverage",
        requires = "nvim-lua/plenary.nvim",
        config = "require('plugins.configs.test.coverage')",
    },

    -- Debugging

    {
        "mfussenegger/nvim-dap",
        config = "require('plugins.configs.dap.dap')",
    },

    {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = "require('plugins.configs.dap.ui')",
        cmd = { "DapContinue", "DapTest" },
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        requires = { "mfussenegger/nvim-dap" },
        config = "require('plugins.configs.dap.virtual-text')",
        cmd = { "DapContinue", "DapTest" },
    },

    {
        "leoluz/nvim-dap-go",
        requires = { "mfussenegger/nvim-dap" },
        config = "require('plugins.configs.dap.go')",
        cmd = { "DapContinue", "DapTest" },
    },

    {
        "mfussenegger/nvim-dap-python",
        requires = { "mfussenegger/nvim-dap" },
        config = "require('plugins.configs.dap.python')",
        cmd = { "DapContinue", "DapTest" },
    },

    -- Colorschemes

    {
        "folke/lsp-colors.nvim",
        event = "BufRead",
    },

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
        config = "require('plugins.configs.colorschemes.catppuccin')",
    },

    { "projekt0n/github-nvim-theme" },

    { "folke/tokyonight.nvim" },

    { "joshdick/onedark.vim" },

    { "shaunsingh/nord.nvim" },

    { "lifepillar/vim-solarized8" },

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

    -- BUG: This plugin suppresses the of a current nvim bug with CursorHold
    -- FIX: Remove this plugin when the bug is fixed: https://github.com/neovim/neovim/issues/12587
    { "antoinemadec/FixCursorHold.nvim" },
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
-- Refactoring features like extracting functions, variables, etc.: https://github.com/ThePrimeagen/refactoring.nvim
-- Follow links in markdown: https://github.com/jakewvincent/mkdnflow.nvim
-- Complete jupyter plugin (author abandoned it in alpha stage): https://github.com/ahmedkhalf/jupyter-nvim
-- Command palette, integrated with which-key: https://github.com/mrjones2014/legendary.nvim
-- DoGe vs Neogen (https://github.com/danymat/neogen)

-- Graveyard

-- {
--     "glepnir/lspsaga.nvim",
--     config = "require('plugins.configs.lspsaga')",
--     cmd = "Lspsaga",
-- },

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
--     "kevinhwang91/nvim-bqf",
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
--     config = "require('plugins.configs.treesitter-context')",
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
