local M = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
}

function M.config()
	require("nvim-treesitter-textobjects").setup({
		select = {
			lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
		},
		move = {
			set_jumps = true, -- whether to set jumps in the jumplist
		},
	})

	-- Keymaps
	-- You can use the capture groups defined in `textobjects.scm`

	-- Select
	vim.keymap.set({ "x", "o" }, "af", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "if", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ac", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ic", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ap", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ip", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ab", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ib", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
	end)

	-- Swap
	vim.keymap.set("n", "<leader>Sl", function()
		require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
	end)
	vim.keymap.set("n", "<leader>Sh", function()
		require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
	end)

	-- Move
	vim.keymap.set({ "n", "x", "o" }, "]c", function()
		require("nvim-treesitter-textobjects.move").goto_next_start("@class.inner", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "]p", function()
		require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "]]", function()
		require("nvim-treesitter-textobjects.move").goto_next_start("@function.inner", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "]C", function()
		require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "]P", function()
		require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "][", function()
		require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[c", function()
		require("nvim-treesitter-textobjects.move").goto_previous_start("@class.inner", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[p", function()
		require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[[", function()
		require("nvim-treesitter-textobjects.move").goto_previous_start("@function.inner", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[C", function()
		require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[P", function()
		require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[]", function()
		require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "]o", function()
		require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "]z", function()
		require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
	end)
end

return M
