local M = {}

M.augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local ignore_filetypes = { "oil" }
local auto_format_enabled = true -- Default

function M.toggle_auto_format()
	auto_format_enabled = not auto_format_enabled
end

function M.format(bufnr)
	-- Disable autoformat on certain filetypes
	if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
		return
	end

	local null_ls_present, _ = pcall(require, "null-ls")
	local conform_present, conform = pcall(require, "conform")

	local null_ls_filter = nil
	if null_ls_present then
		null_ls_filter = function(client)
			return client.name == "null-ls"
		end
	end

	if conform_present then
		conform.format({ timeout_ms = 2000, lsp_format = "fallback", bufnr = bufnr })
	else
		vim.lsp.buf.format({
			filter = null_ls_filter,
			bufnr = bufnr,
		})
	end

	vim.notify("Formatted the buffer", "info")
end

function M.auto_format(bufnr)
	if auto_format_enabled then
		M.format(bufnr)
	end
end

return M
