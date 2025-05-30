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
			relative = "editor",
			border = "single",
			style = "minimal",
			scope = "line",
			focusable = false,
			mouse = true,
			-- source = "if_many",
			source = false, -- handled by the format function
			header = " Diagnostics ",
			prefix = "",
			suffix = "",
			format = function(d)
				local message = d.message
				local source = d.source
				local code = d.code
				local last_char = message:sub(-1)
				while last_char == ":" or last_char == " " or last_char == "." do
					message = message:sub(1, -2)
					last_char = message:sub(-1)
				end
				if source then
					last_char = source:sub(-1)
					while last_char == ":" or last_char == " " or last_char == "." do
						source = source:sub(1, -2)
						last_char = source:sub(-1)
					end
				end
				if code then
					last_char = code:sub(-1)
					while last_char == ":" or last_char == " " or last_char == "." do
						code = code:sub(1, -2)
						last_char = code:sub(-1)
					end
				end

				local str = " "
				if d.severity == vim.diagnostic.severity.ERROR then
					str = str .. icons.diagnostics.error
				elseif d.severity == vim.diagnostic.severity.WARN then
					str = str .. icons.diagnostics.warning
				elseif d.severity == vim.diagnostic.severity.INFO then
					str = str .. icons.diagnostics.info
				elseif d.severity == vim.diagnostic.severity.HINT then
					str = str .. icons.diagnostics.hint
				end
				str = str .. " " .. message
				if source then
					str = str .. " [" .. source
					if code then
						str = str .. ": " .. code .. "]"
					else
						str = str .. "]"
					end
				end
				return str .. " "
			end,
		},
		update_in_insert = false,
		severity_sort = true,
	})

	-- Show errors and warnings in a floating window
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			local _, win = vim.diagnostic.open_float()

			-- Hack to position the diagnostic window in the upper right corner
			if not win then
				return
			end
			local cfg = vim.api.nvim_win_get_config(win)
			cfg.row = 1 -- to account for the winbar
			cfg.col = vim.o.columns - 1
			cfg.width = math.min(cfg.width or 999, math.floor(vim.o.columns * 0.6))
			cfg.height = math.min(cfg.height or 999, math.floor(vim.o.lines * 0.4))

			-- If it hides the line where the cursor is, move it down
			local cursor_row = vim.fn.winline()
			if cfg.row + cfg.height - 1 >= cursor_row then
				cfg.row = cursor_row + 1
			end

			vim.api.nvim_win_set_config(win, cfg)
		end,
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
