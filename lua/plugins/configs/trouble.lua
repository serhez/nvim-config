local M = {
	"folke/trouble.nvim",
	cmd = "Trouble",
}

function M.init()
	-- FIX: Make "gc" and "gC" work
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

		{ "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
		{ "<leader>cD", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
		{ "<leader>cu", "<cmd>Trouble lsp<cr>", desc = "Usage" },

		{ "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
		{ "<leader>lD", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },

		{ "<leader>Ul", "<cmd>Trouble loclist<cr>", desc = "Location list" },
		{ "<leader>Uq", "<cmd>Trouble qflist<cr>", desc = "Quickfix list" },
	})

	-- Hijack quickfix and location list
	-- We still want to avoid calling the original commands as much as possible,
	-- in order to avoid the overhead of closing and reopening the window
	-- vim.api.nvim_create_autocmd("BufRead", {
	-- 	callback = function(ev)
	-- 		if vim.bo[ev.buf].buftype == "quickfix" then
	-- 			vim.schedule(function()
	-- 				vim.cmd([[cclose]])
	-- 				require("trouble").open({ mode = "qflist" })
	-- 			end)
	-- 		elseif vim.bo[ev.buf].buftype == "loclist" then
	-- 			vim.schedule(function()
	-- 				vim.cmd([[lclose]])
	-- 				require("trouble").open({ mode = "loclist" })
	-- 			end)
	-- 		end
	-- 	end,
	-- })
end

function M.config()
	require("trouble").setup({
		pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
		focus = true, -- Focus the window when opened
		follow = true, -- Follow the current item
		auto_jump = true,
		warn_no_results = true, -- show a warning when there are no results
		open_no_results = false,
		preview = {
			type = "split",
			relative = "win",
			position = "right",
			size = 0.4,
		},
		keys = {
			["_"] = "jump_split",
			["|"] = "jump_vsplit",
		},
		modes = {
			lsp_base = {
				params = {
					include_current = true,
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
