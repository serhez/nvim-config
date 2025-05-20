local M = {}

local function lspSymbol(name, icon)
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

function M.setup()
	local icons = require("icons")

	-- Diagnostics
	lspSymbol("Error", icons.diagnostics.error)
	lspSymbol("Info", icons.diagnostics.info)
	lspSymbol("Hint", icons.diagnostics.hint)
	lspSymbol("Warn", icons.diagnostics.warning)

	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
				[vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
				[vim.diagnostic.severity.INFO] = icons.diagnostics.info,
				[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
			},
		},
		underline = {
			severity = vim.diagnostic.severity.WARN,
		},
		float = {
			focusable = false,
			border = "single",
			source = false,
			header = "",
			prefix = "",
			suffix = "",
			format = function(d)
				local str = "  "
				if d.severity == vim.diagnostic.severity.ERROR then
					str = str .. icons.diagnostics.error .. " "
				elseif d.severity == vim.diagnostic.severity.WARN then
					str = str .. icons.diagnostics.warning .. " "
				elseif d.severity == vim.diagnostic.severity.INFO then
					str = str .. icons.diagnostics.info .. " "
				elseif d.severity == vim.diagnostic.severity.HINT then
					str = str .. icons.diagnostics.hint .. " "
				end
				return str .. d.message .. "  "
			end,
		},
		-- float = false,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Save after renaming
	local rename_handler = vim.lsp.handlers["textDocument/rename"]
	vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
		rename_handler(err, result, ctx, config)

		if err or not result then
			return
		end

		local function write_buf(buf)
			if buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd("w")
				end)
			end
		end
		if result.changes then
			for uri, _ in pairs(result.changes) do
				local buf = vim.uri_to_bufnr(uri)
				write_buf(buf)
			end
		elseif result.documentChanges then
			for _, change in ipairs(result.documentChanges) do
				local buf = vim.uri_to_bufnr(change.textDocument.uri)
				write_buf(buf)
			end
		end
	end
end

return M
