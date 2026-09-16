local M = {
	"esmuellert/codediff.nvim",
	cmd = {
		"CodeDiff",
	},
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

local function setup_tab_name()
	local group = vim.api.nvim_create_augroup("UserCodeDiffTabName", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "CodeDiffOpen",
		callback = function(event)
			local tabpage = event.data and event.data.tabpage
			local ok, tabern = pcall(require, "tabern")
			if ok and tabpage and vim.api.nvim_tabpage_is_valid(tabpage) then
				tabern.set_name("Diff", tabpage)
			end
		end,
		desc = "Name CodeDiff tabs",
	})
end

function M.init()
	require("mappings").register({
		{ "<leader>gx", group = "Conflicts" },
		{ "<leader>gxa", group = "All" },
		{ "<leader>gc", "<cmd>CodeDiff history HEAD~100 %<cr>", desc = "Commits (file)" },
		{ "<leader>gC", "<cmd>CodeDiff history HEAD~100<cr>", desc = "Commits (workspace)" },
		{ "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diffs tool" },
		{ "<leader>gD", ":CodeDiff ", desc = "Diffs tool (specify targets)" },
		{ "<leader>gf", "<cmd>CodeDiff --inline file HEAD<cr>", desc = "Inline file diffs" },
		{ "<leader>gP", ":CodeDiff pr ", desc = "Review pull request" },
		{ "<leader>gS", "<cmd>CodeDiff --staged<cr>", desc = "Staged diffs" },
	})
end

function M.config()
	setup_tab_name()

	require("codediff").setup({
		diff = {
			layout = "inline",
			compact = true,
			cycle_hunks_across_files = true,
		},
		explorer = {
			auto_open_on_cursor = false,
			focus_on_select = true,
		},
		keymaps = {
			explorer = {
				select = { "<CR>", "l" },
			},
			conflict = {
				accept_incoming = false,
				accept_current = false,
				accept_both = false,
				accept_all_incoming = "<leader>gxat", -- Accept ALL incoming changes
				accept_all_current = "<leader>gxao", -- Accept ALL current changes
				accept_all_both = "<leader>gxab", -- Accept ALL both changes
				discard_all = "<leader>gxax", -- Discard ALL, reset to base
				discard = false,
				next_conflict = false,
				prev_conflict = false,
				diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
				diffget_current = "3do", -- Get hunk from current (right/ours) buffer
			},
		},
	})

	require("window_backgrounds").setup_dark_bg_filetypes("UserCodeDiffDarkBackground", { "codediff-explorer" })
end

return M
