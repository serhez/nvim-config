local M = {
	"copilotlsp-nvim/copilot-lsp",
	-- event = "VeryLazy",
	enabled = false, -- BUG: it just constantly throws errors
}

function M.init()
	local version = vim.version()
	local nes = require("copilot-lsp.nes")

	-- TODO: Do not attatch to markdown and other fileypes (see copilot.lua config)
	vim.lsp.config("copilot_ls", {
		name = "copilot_ls",
		cmd = {
			"copilot-language-server",
			"--stdio",
		},
		init_options = {
			editorInfo = {
				name = "neovim",
				version = string.format("%d.%d.%d", version.major, version.minor, version.patch),
			},
			editorPluginInfo = {
				name = "Github Copilot LSP for Neovim",
				version = "0.0.1",
			},
		},
		settings = {
			nextEditSuggestions = {
				enabled = true,
			},
		},
		handlers = setmetatable({}, {
			__index = function(_, method)
				return require("copilot-lsp.handlers")[method]
			end,
		}),
		root_dir = function(bufnr, on_dir)
			-- Do not attach to certain filetypes
			if
				vim.bo[bufnr].filetype == "markdown"
				or vim.bo[bufnr].filetype == "yaml"
				or vim.bo[bufnr].filetype == "json"
				or vim.bo[bufnr].filetype == "toml"
				or vim.bo[bufnr].filetype == "help"
				or vim.bo[bufnr].filetype == "gitcommit"
				or vim.bo[bufnr].filetype == "gitrebase"
				or vim.bo[bufnr].filetype == "hgcommit"
				or vim.bo[bufnr].filetype == "svn"
				or vim.bo[bufnr].filetype == "cvs"
				or vim.bo[bufnr].filetype == "oil"
				or vim.bo[bufnr].filetype == "grug-far"
				or vim.bo[bufnr].filetype == "."
			then
				return nil
			end
			on_dir(vim.uv.cwd())
		end,
		on_init = function(client)
			local au = vim.api.nvim_create_augroup("copilotlsp.init", { clear = true })

			--NES Completions
			local debounced_request =
				require("copilot-lsp.util").debounce(nes.request_nes, vim.g.copilot_nes_debounce or 500)
			vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
				callback = function()
					debounced_request(client)
				end,
				group = au,
			})

			--didFocus
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					local td_params = vim.lsp.util.make_text_document_params()
					client:notify("textDocument/didFocus", {
						textDocument = {
							uri = td_params.uri,
						},
					})
				end,
				group = au,
			})
		end,
	})

	vim.lsp.enable("copilot_ls")

	require("mappings").register({
		{ "<leader>as", group = "Suggestions" },
		{
			"<leader>asn",
			function()
				nes.request_nes("copilot_ls")
			end,
			desc = "Request next",
		},
		{
			"<leader>asc",
			function()
				nes.clear_suggestion()
			end,
			desc = "Clear",
		},
	})

	vim.keymap.set({ "n", "x", "o", "i", "v" }, "<C-s>", function()
		-- Try to jump to the start of the suggestion edit.
		-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
		local _ = nes.walk_cursor_start_edit() or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
	end, { desc = "Jump or apply AI suggestion" })
	vim.keymap.set({ "n", "x", "o", "i", "v" }, "<C-S-s>", function()
		nes.clear()
	end, { desc = "Clear AI suggestion" })
	vim.keymap.set("n", "<esc>", function()
		if not nes.clear() then
			-- fallback to other functionality
			return
		end
	end, { desc = "Clear AI suggestion" })
end

function M.config()
	vim.g.copilot_nes_debounce = 500

	require("copilot-lsp").setup({
		nes = {
			move_count_threshold = 3, -- Clear after 3 cursor movements
			distance_threshold = 40,
			clear_on_large_distance = true,
			count_horizontal_moves = true,
			reset_on_approaching = true,
		},
	})
end

return M
