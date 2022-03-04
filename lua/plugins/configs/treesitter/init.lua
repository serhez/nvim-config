require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    ignore_install = { "phpdoc" },

    highlight = {
        enable = true,
        use_languagetree = true,
    },
    -- indent = {enable = true, disable = {"python", "html", "javascript"}}, -- FIX: LSP indenting seems to be broken
    indent = {enable = false},
    -- autotag = {enable = true},

    matchup = {
        enable = true -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },

    context_commentstring = {
        enable = true,
        config = {css = '// %s'}
    },

    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ap"] = "@parameter.outer",
                ["ip"] = "@parameter.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
            },
        },
        -- swap = {
        --     enable = true,
        --     swap_next = {
        --         ["<leader>a"] = "@parameter.inner",
        --     },
        --     swap_previous = {
        --         ["<leader>A"] = "@parameter.inner",
        --     },
        -- },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]]"] = "@function.outer",
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]p"] = "@parameter.outer",
            },
            goto_next_end = {
                ["]["] = "@function.outer",
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
                ["]P"] = "@parameter.outer",
            },
            goto_previous_start = {
                ["[["] = "@function.outer",
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[p"] = "@parameter.outer",
            },
            goto_previous_end = {
                ["[]"] = "@function.outer",
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
                ["[P"] = "@parameter.outer",
            },
        },
    },

    textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
        }
    },
}

