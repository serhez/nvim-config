local M = {
	"techwizrd/render-latex.nvim",
}

-- Keep render-latex's buffer-change handler off Neovim's synchronous change path.
--
-- render-latex attaches an `on_lines` callback that runs an incremental
-- Treesitter scan (Detect.update -> parser:parse()) inline. Neovim delivers that
-- notification while a multi-line edit is only half applied: `do_join` (an
-- insert-mode <BS> at column 0) reports the joined first line *before* deleting
-- the lines it absorbed, so a parse there sees buffer text that contradicts the
-- edit the parser was just handed.
--
-- The Markdown grammar's external scanner does not survive that. Its open-block
-- stack underflows (`pop_block` decrements an unsigned size past zero) and the
-- next serialize call memcpy's ~2^64 bytes, which kills the process with SIGBUS:
-- no Lua error, no recovery, the whole editor is gone. Minimal trigger is four
-- lines -- a heading, a blank line, then two list items -- with <BS> at the
-- start of the first list item.
--
-- Deferring the callback to `vim.schedule` moves the parse to the next event
-- loop tick, when buffer and parser agree again. The plugin's own callback is
-- reused untouched, so only *when* it runs changes; its +/-50-line rescan window
-- absorbs the coordinate skew when several changes land in the same tick.
--
-- This has to be wired up before the plugin loads: lazy.nvim sources a plugin's
-- `plugin/` directory -- which is where render-latex calls `setup()` and attaches
-- to visible buffers -- before it runs `config()`. Hence the `nvim_buf_attach`
-- wrapper in `init()` rather than a patch of `Renderer.attach` in `config()`.

-- The callback detaches by returning true. A scheduled call cannot report that
-- back to Neovim, so remember it and detach on the next change.
local detach_requested = {} ---@type table<integer, boolean>

local function defer(on_lines)
	return function(event, buffer, ...)
		if detach_requested[buffer] then
			detach_requested[buffer] = nil
			return true
		end
		local args = vim.F.pack_len(event, buffer, ...)
		vim.schedule(function()
			if on_lines(vim.F.unpack_len(args)) == true then
				detach_requested[buffer] = true
			end
		end)
	end
end

function M.init()
	local buf_attach = vim.api.nvim_buf_attach
	vim.api.nvim_buf_attach = function(buf, send_buffer, opts)
		if type(opts) == "table" and type(opts.on_lines) == "function" then
			local info = debug.getinfo(opts.on_lines, "S")
			if info ~= nil and info.source:find("render_latex", 1, true) ~= nil then
				opts = vim.tbl_extend("force", opts, { on_lines = defer(opts.on_lines) })
			end
		end
		return buf_attach(buf, send_buffer, opts)
	end
end

function M.config()
	require("render_latex").setup({
		render = {
			preset = "match_text", -- "match_text", "compact", or "presentation"
			inline = "conceal", -- "content", "highlight", or false
			inline_symbols = true,
			hide_on_cmdline = false,
		},
	})
end

return M
