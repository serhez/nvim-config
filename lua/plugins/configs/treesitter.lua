local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-textsubjects",
		"RRethy/nvim-treesitter-endwise",
	},
	event = "VeryLazy",
}

function M.init()
	require("mappings").register({ "<leader>it", "<cmd>TSUpdate<cr>", desc = "Update treesitter" })
	require("mappings").register({ "<leader>iT", "<cmd>TSInstall all<cr>", desc = "Install treesitter (all)" })
end

function M.config()
	require("nvim-treesitter.configs").setup({
		-- ensure_installed = "all", -- NOTE: this makes startup slow
		-- ignore_install = { "liquidsoap", "beancount", "norg" }, -- NOTE: they are bugged (06.10.2023)

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
			-- disable = function(_, bufnr)
			-- 	local buf_name = vim.api.nvim_buf_get_name(bufnr)
			-- 	local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
			-- 	return file_size > 256 * 1024
			-- end,
			is_supported = function()
				-- Since `ibhagwan/fzf-lua` returns `bufnr/path` like `117/lua/plugins/colors.lua`.
				local cur_path = (vim.fn.expand("%"):gsub("^%d+/", ""))
				if
					cur_path:match("term://")
					or vim.fn.getfsize(cur_path) > 1024 * 1024 -- file size > 1 MB.
					or vim.fn.strwidth(vim.fn.getline(".")) > 300 -- width > 300 chars.
				then
					return false
				end
				return true
			end,
		},

		indent = { enable = true },
		endwise = { enable = true },

		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
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
			swap = {
				enable = true,
				swap_next = {
					["Sl"] = "@parameter.inner",
				},
				swap_previous = {
					["Sh"] = "@parameter.inner",
				},
			},
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
					["]F"] = "@function.inner",
					["]C"] = "@class.inner",
					["]P"] = "@parameter.inner",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[p"] = "@parameter.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.inner",
					["[F"] = "@function.inner",
					["[C"] = "@class.inner",
					["[P"] = "@parameter.inner",
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

	-- Register md-related filetypes with the md parser
	vim.treesitter.language.register("markdown", "pandoc")
	vim.treesitter.language.register("markdown", "rmd")
	vim.treesitter.language.register("markdown", "quarto")

	-- Center the screen after jumping to next/previous function
	vim.keymap.set(
		"n",
		"]]",
		":TSTextobjectGotoNextStart @function.inner | lua vim.cmd('norm zz') <CR>",
		{ remap = true, desc = "Go to next function and center the cursor" }
	)
	vim.keymap.set(
		"n",
		"[[",
		":TSTextobjectGotoPreviousStart @function.inner | lua vim.cmd('norm zz') <CR>",
		{ remap = true, desc = "Go to previous function and center the cursor" }
	)
end

return M
