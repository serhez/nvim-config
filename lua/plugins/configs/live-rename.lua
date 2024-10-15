local M = {
	"saecki/live-rename.nvim",
}

function M.init()
	require("mappings").register({
		"<leader>cr",
		function()
			require("live-rename").rename()
			vim.cmd("wa") -- save all buffers
		end,
		desc = "Rename keyword",
	})
end

function M.config()
	require("live-rename").setup({
		-- Send a `textDocument/prepareRename` request to the server to
		-- determine the word to be renamed, can be slow on some servers.
		-- Otherwise fallback to using `<cword>`.
		prepare_rename = true,
		request_timeout = 1500,
		keys = {
			submit = {
				{ "n", "<cr>" },
				{ "v", "<cr>" },
				{ "i", "<cr>" },
			},
			cancel = {
				{ "n", "<esc>" },
				{ "n", "q" },
			},
		},
		hl = {
			current = "CurSearch",
			others = "Search",
		},
	})
end

return M
