local M = {
	"nvim-mini/mini.hipatterns",
	-- version = "*",
	event = "VeryLazy",
	enabled = false,
}

function M.config()
	local hipatterns = require("mini.hipatterns")

	hipatterns.setup({
		highlighters = {
			hex_color = hipatterns.gen_highlighter.hex_color({
				style = "inline",
				-- inline_text = "",
			}),
		},
	})
end

return M
