local M = {}

-- Formatting

M.augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local auto_format_enabled = true -- Default

function M.toggle_auto_format()
	auto_format_enabled = not auto_format_enabled
end

function M.format(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

function M.auto_format(bufnr)
	if auto_format_enabled then
		M.format(bufnr)
	end
end

return M
