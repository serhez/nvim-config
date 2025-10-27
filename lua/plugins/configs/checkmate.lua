local M = {
	"bngarren/checkmate.nvim",
	ft = { "markdown", "quarto" },
}

function M.init()
	require("mappings").register({
		{ "<leader>T", group = "Checkmarks" },
		{
			"<leader>Tt",
			"<cmd>Checkmate toggle<CR>",
			desc = "Toggle",
			mode = { "n", "v" },
		},
		{
			"<leader>Tc",
			"<cmd>Checkmate check<CR>",
			desc = "Set as checked",
			mode = { "n", "v" },
		},
		{
			"<leader>Tu",
			"<cmd>Checkmate uncheck<CR>",
			desc = "Set unchecked",
			mode = { "n", "v" },
		},
		{
			"<leader>T=",
			"<cmd>Checkmate cycle_next<CR>",
			desc = "Cycle next",
			mode = { "n", "v" },
		},
		{
			"<leader>T-",
			"<cmd>Checkmate cycle_previous<CR>",
			desc = "Cycle previous",
			mode = { "n", "v" },
		},
		{
			"<leader>Tn",
			"<cmd>Checkmate create<CR>",
			desc = "Create",
			mode = { "n", "v" },
		},
		{
			"<leader>Tr",
			"<cmd>Checkmate remove<CR>",
			desc = "Remove",
			mode = { "n", "v" },
		},
		{
			"<leader>TR",
			"<cmd>Checkmate remove_all_metadata<CR>",
			desc = "Remove metadata",
			mode = { "n", "v" },
		},
		{
			"<leader>Ta",
			"<cmd>Checkmate archive<CR>",
			desc = "Archive checked items",
			mode = { "n" },
		},
		{
			"<leader>Tv",
			"<cmd>Checkmate metadata select_value<CR>",
			desc = "Update meta-value",
			mode = { "n" },
		},
		{
			"<leader>T]",
			"<cmd>Checkmate metadata jump_next<CR>",
			desc = "Go to next checkmark",
			mode = { "n" },
		},
		{
			"[T",
			"<cmd>Checkmate metadata jump_previous<CR>",
			desc = "Go to previous checkmark",
			mode = { "n" },
		},
	})
end

function M.config()
	require("checkmate").setup({
		files = {
			"*.md",
			"*.qmd",
		},
		log = {
			use_file = false,
		},
		todo_states = {
			unchecked = {
				marker = "[ ]",
				order = 1,
			},
			checked = {
				marker = "[x]",
				order = 2,
			},
		},
		keys = false,
		todo_count_recursive = false,
	})
end

return M
