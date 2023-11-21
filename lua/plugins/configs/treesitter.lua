local mappings = require("mappings")

local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-textsubjects",
		"windwp/nvim-ts-autotag",
	},
	event = "BufReadPost",
}

function M.init()
	mappings.register_normal({
		i = {
			t = { "<cmd>TSUpdate<cr>", "Update treesitter" },
		},
	})
end

function M.config()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		ignore_install = { "liquidsoap", "beancount", "norg" }, -- they are bugged (06.10.2023)

		highlight = {
			enable = true,
			use_languagetree = true,
		},

		indent = { enable = true },
		autotag = { enable = true },

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
				["."] = "textsubjects-smart",
				[";"] = "textsubjects-container-outer",
			},
		},
	})
end

return M
