local M = {
	"folke/trouble.nvim",
	cmd = "Trouble",
}

function M.init()
	-- FIX: Make "gc" and "gC" work

	-- Disable default LSP mappings
	vim.api.nvim_del_keymap("n", "grn")
	vim.api.nvim_del_keymap("n", "gra")
	vim.api.nvim_del_keymap("v", "gra")
	vim.api.nvim_del_keymap("n", "grr")
	vim.api.nvim_del_keymap("n", "gri")
	vim.api.nvim_del_keymap("n", "grt")
	vim.api.nvim_del_keymap("n", "gO")

	-- Override quickfile and location list mappings
	vim.api.nvim_del_keymap("n", "[q")
	vim.api.nvim_del_keymap("n", "]q")
	vim.api.nvim_del_keymap("n", "[Q")
	vim.api.nvim_del_keymap("n", "]Q")
	vim.api.nvim_del_keymap("n", "[l")
	vim.api.nvim_del_keymap("n", "]l")
	vim.api.nvim_del_keymap("n", "[L")
	vim.api.nvim_del_keymap("n", "]L")

	require("mappings").register({
		-- x = {
		-- 	"<cmd>Trouble mode=lsp_document_symbols pinned=true win.position=right win.relative=win auto_preview=false<cr>",
		-- 	"Trouble",
		-- },
		{ "ga", "<cmd>Trouble lsp<cr>", desc = "All usage" },
		{ "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "Definitions" },
		{ "gD", "<cmd>Trouble lsp_declarations<cr>", desc = "Declarations" },
		{ "gi", "<cmd>Trouble lsp_implementations<cr>", desc = "Implementations" },
		{ "gr", "<cmd>Trouble lsp_references<cr>", desc = "References" },
		{ "gt", "<cmd>Trouble lsp_type_definitions<cr>", desc = "Type definitions" },
		{ "gI", "<cmd>Trouble lsp_incoming_calls<cr>", desc = "Incoming calls" },
		{ "gO", "<cmd>Trouble lsp_outgoing_calls<cr>", desc = "Outgoing calls" },

		-- Quickfix and location list
		{ "<leader>l", "<cmd>Trouble loclist<cr>", desc = "Toggle location" },
		{ "<leader>q", "<cmd>Trouble qflist<cr>", desc = "Toggle quickfix" },
		{
			"[q",
			function()
				require("trouble").prev("qflist")
				require("trouble").jump_only("qflist")
			end,
			desc = "Previous quickfix list item",
		},
		{
			"]q",
			function()
				require("trouble").next("qflist")
				require("trouble").jump_only("qflist")
			end,
			desc = "Next quickfix list item",
		},
		{
			"[Q",
			function()
				require("trouble").first("qflist")
				require("trouble").jump_only("qflist")
			end,
			desc = "First quickfix list item",
		},
		{
			"]Q",
			function()
				require("trouble").last("qflist")
				require("trouble").jump_only("qflist")
			end,
			desc = "Last quickfix list item",
		},
		{
			"[l",
			function()
				require("trouble").prev("loclist")
				require("trouble").jump_only("loclist")
			end,
			desc = "Previous location list item",
		},
		{
			"]l",
			function()
				require("trouble").next("loclist")
				require("trouble").jump_only("loclist")
			end,
			desc = "Next location list item",
		},
		{
			"[L",
			function()
				require("trouble").first("loclist")
				require("trouble").jump_only("loclist")
			end,
			desc = "First location list item",
		},
		{
			"]L",
			function()
				require("trouble").last("loclist")
				require("trouble").jump_only("loclist")
			end,
			desc = "Last location list item",
		},

		{ "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
		{
			"<leader>cD",
			function()
				-- Analyse all files for diagnostics
				-- NOTE: The drawback of this manual approach is that it will only scan the
				--       diagnostics of files of the same type (or at least those which use
				--       the same LSP client)
				for _, client in ipairs(vim.lsp.buf_get_clients()) do
					require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
				end

				-- Open the diagnostics window with a delay to wait for diagnostics
				vim.defer_fn(function()
					require("trouble").toggle("diagnostics")
				end, 1000)
			end,
			desc = "Diagnostics (workspace)",
		},
		{ "<leader>cu", "<cmd>Trouble lsp<cr>", desc = "Usage" },
	})

	-- Hijack quickfix and location list
	-- We still want to avoid calling the original commands as much as possible,
	-- in order to avoid the overhead of closing and reopening the window
	vim.api.nvim_create_autocmd("BufRead", {
		callback = function(ev)
			if vim.bo[ev.buf].buftype == "quickfix" then
				vim.schedule(function()
					vim.cmd([[cclose]])
					require("trouble").open({ mode = "qflist" })
				end)
			elseif vim.bo[ev.buf].buftype == "loclist" then
				vim.schedule(function()
					vim.cmd([[lclose]])
					require("trouble").open({ mode = "loclist" })
				end)
			end
		end,
	})
end

function M.config()
	require("trouble").setup({
		auto_close = false, -- auto close when there are no items
		auto_open = false, -- auto open when there are items
		auto_preview = true, -- automatically open preview when on an item
		auto_refresh = true, -- auto refresh when open
		auto_jump = true, -- auto jump to the item when there's only one
		focus = true, -- Focus the window when opened
		restore = true, -- restores the last location in the list when opening
		follow = false, -- Follow the current item
		indent_guides = true, -- show indent guides
		max_items = 500, -- limit number of items that can be displayed per section
		multiline = true, -- render multi-line messages
		pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
		warn_no_results = true, -- show a warning when there are no results
		open_no_results = false, -- open the trouble window when there are no results
		preview = {
			-- type = "split",
			-- relative = "win",
			-- position = "right",
			-- size = 0.4,
			type = "float",
			relative = "editor",
			border = "solid",
			title = "Preview",
			title_pos = "center",
			position = { 0, -2 },
			size = { width = 0.4, height = 11 },
			zindex = 200,
		},
		keys = {
			["_"] = "jump_split",
			["|"] = "jump_vsplit",
		},
		modes = {
			lsp_base = {
				auto_refresh = false,
				params = {
					include_current = true,
				},
			},
			loclist = {
				win = {
					position = "top",
					relative = "editor",
					size = 10,
				},
				preview = {
					type = "float",
					position = { -2, -2 },
					relative = "editor",
					border = "solid",
					title = "Preview",
					title_pos = "center",
					size = { width = 0.4, height = 11 },
					zindex = 200,
				},
			},
			symbols = {
				title = "{hl:Title}Document Symbols{hl} {count}",
				desc = "Document symbols",
				mode = "lsp_document_symbols",
				source = "lsp.document_symbols",
				auto_preview = false,
				pinned = true,
				win = { position = "right", relative = "win" },
				filter = {
					-- remove Package since luals uses it for control flow structures
					["not"] = { ft = "lua", kind = "Package" },
					any = {
						-- all symbol kinds for help / markdown files
						ft = { "help", "markdown" },
						-- default set of symbol kinds
						kind = {
							"Class",
							"Constructor",
							"Enum",
							"Field",
							"Function",
							"Interface",
							"Method",
							"Module",
							"Namespace",
							"Package",
							"Property",
							"Struct",
							"Trait",
						},
					},
				},
			},
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		TroubleNormal = { bg = c.statusline_bg, fg = c.statusline_fg },
	})
end

return M
