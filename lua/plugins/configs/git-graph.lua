local M = {
	"isakbm/gitgraph.nvim",
	dependencies = { "sindrets/diffview.nvim" },
}

function M.init()
	require("mappings").register({
		"<leader>gg",
		function()
			require("gitgraph").draw({}, { all = true, max_count = 5000 })
		end,
		desc = "Graph",
	})
end

function M.config()
	require("gitgraph").setup({
		-- symbols = {
		-- 	merge_commit = "",
		-- 	commit = "",
		-- 	merge_commit_end = "",
		-- 	commit_end = "",
		--
		-- 	-- Advanced symbols
		-- 	GVER = "",
		-- 	GHOR = "",
		-- 	GCLD = "",
		-- 	GCRD = "╭",
		-- 	GCLU = "",
		-- 	GCRU = "",
		-- 	GLRU = "",
		-- 	GLRD = "",
		-- 	GLUD = "",
		-- 	GRUD = "",
		-- 	GFORKU = "",
		-- 	GFORKD = "",
		-- 	GRUDCD = "",
		-- 	GRUDCU = "",
		-- 	GLUDCD = "",
		-- 	GLUDCU = "",
		-- 	GLRDCL = "",
		-- 	GLRDCR = "",
		-- 	GLRUCL = "",
		-- 	GLRUCR = "",
		-- },
		format = {
			timestamp = "%H:%M:%S %d-%m-%Y",
			fields = { "hash", "timestamp", "author", "branch_name", "tag" },
		},

		-- Integration with diffview.nvim
		hooks = {
			-- Check diff of a commit
			on_select_commit = function(commit)
				vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
			end,

			-- Check diff from commit a -> commit b
			on_select_range_commit = function(from, to)
				vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
			end,
		},
	})
end

return M
