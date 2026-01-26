local M = {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-endwise",
	},
}

function M.init()
	require("mappings").register({ "<leader>it", "<cmd>TSUpdate<cr>", desc = "Update parsers" })
	require("mappings").register({ "<leader>iT", "<cmd>TSInstall all<cr>", desc = "Install parsers (all)" })

	-- Register md-related filetypes with the md parser
	vim.treesitter.language.register("markdown", "pandoc")
	vim.treesitter.language.register("markdown", "rmd")
	vim.treesitter.language.register("markdown", "quarto")

	-- Custom parser for comments
	vim.api.nvim_create_autocmd("User", {
		pattern = "TSUpdate",
		callback = function()
			require("nvim-treesitter.parsers").comment = {
				install_info = {
					url = "https://github.com/OXY2DEV/tree-sitter-comment",
					queries = "queries/",
				},
			}
		end,
	})
end

function M.config()
	-- Enable treesitter capabilities
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf = args.buf
			local filetype = args.match

			-- Check if a parser exists for the current language
			local language = vim.treesitter.language.get_lang(filetype) or filetype
			if not vim.treesitter.language.add(language) then
				return
			end

			-- Folding; currently managed by `ufo.nvim` plugin
			-- vim.wo.foldmethod = "expr"
			-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

			-- Highlighting
			vim.treesitter.start(buf, language)

			-- Indentation
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

return M
