local M = {
	"rachartier/tiny-glimmer.nvim",
	event = "VeryLazy",
	enabled = false,
}

function M.config()
	require("tiny-glimmer").setup({
		enabled = true,
		overwrite = {
			-- Automatically map keys to overwrite operations
			-- If set to false, you will need to call the API functions to trigger the animations
			-- WARN: You should disable this if you have already mapped these keys
			--        or if you want to use the API functions to trigger the animations
			auto_map = true,

			yank = {
				enabled = true,
			},
			search = {
				enabled = true,
			},
			paste = {
				enabled = true,
			},
			undo = {
				enabled = true,
			},
			redo = {
				enabled = true,
			},
		},
	})
end

return M
