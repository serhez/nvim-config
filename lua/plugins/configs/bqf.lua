local M = {
	"kevinhwang91/nvim-bqf",
	event = "VeryLazy",
}

function M.config()
	local icons = require("icons")

	require("bqf").setup({
		auto_resize_height = true,
		preview = {
			border_chars = icons.border.straight_bqf,
			wrap = false,
			should_preview_cb = function(bufnr, _)
				local ret = true
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				local fsize = vim.fn.getfsize(bufname)
				if fsize > 100 * 1024 then
					-- skip file size greater than 100k
					ret = false
				elseif bufname:match("^fugitive://") then
					-- skip fugitive buffer
					ret = false
				end
				return ret
			end,
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		BqfPreviewBorder = common_hls.no_border_statusline,
		BqfPreviewFloat = { bg = c.statusline_bg },
	})
end

return M
