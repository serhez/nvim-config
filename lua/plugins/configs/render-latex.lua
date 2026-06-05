local M = {
	"techwizrd/render-latex.nvim",
}

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
