vim.g.loaded_matchit = 1
vim.g.matchup_matchparen_offscreen = {method = 'popup'}

require'nvim-treesitter.configs'.setup {
    matchup = {
        enable = true,
    },
}
