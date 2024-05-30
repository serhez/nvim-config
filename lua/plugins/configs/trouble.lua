local M = {
	"folke/trouble.nvim",
	cmd = "Trouble",
}

-- TODO: Hijack quickfix and location list (particularly for gd gr, etc)
function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		c = {
			d = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Diagnostics (buffer)" },
			D = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (workspace)" },
			u = { "<cmd>Trouble lsp<cr>", "Usage" },
		},
		l = {
			d = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Diagnostics (buffer)" },
			D = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (workspace)" },
		},
		U = {
			l = { "<cmd>Trouble loclist<cr>", "Location list" },
			q = { "<cmd>Trouble qflist<cr>", "Quickfix list" },
		},
	})

	-- FIX: Make "gc" and "gC" work
	vim.api.nvim_set_keymap("n", "ga", "<cmd>Trouble lsp<cr>", { noremap = true, silent = true, desc = "All usage" })
	vim.api.nvim_set_keymap(
		"n",
		"gd",
		"<cmd>Trouble lsp_definitions<cr>",
		{ noremap = true, silent = true, desc = "Definitions" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gD",
		"<cmd>Trouble lsp_declarations<cr>",
		{ noremap = true, silent = true, desc = "Declarations" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gi",
		"<cmd>Trouble lsp_implementations<cr>",
		{ noremap = true, silent = true, desc = "Implementations" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gr",
		"<cmd>Trouble lsp_references<cr>",
		{ noremap = true, silent = true, desc = "References" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gt",
		"<cmd>Trouble lsp_type_definitions<cr>",
		{ noremap = true, silent = true, desc = "Type definitions" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gc",
		"<cmd>Trouble lsp_incoming_calls<cr>",
		{ noremap = true, silent = true, desc = "Incoming calls" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gC",
		"<cmd>Trouble lsp_outgoing_calls<cr>",
		{ noremap = true, silent = true, desc = "Outgoing calls" }
	)

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
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		TroubleNormal = { bg = c.statusline_bg, fg = c.statusline_fg },
	})
end

return M
