local M = {
	"kylechui/nvim-surround",
	event = "VeryLazy",
}

function M.config()
	require("nvim-surround").setup({
		keymaps = {
			insert = "<C-g>s",
			insert_line = "<C-g>S",
			normal = "s",
			normal_cur = "ss",
			-- normal_line = "S",
			-- normal_cur_line = "SS",
			visual = "s",
			visual_line = "gs",
			delete = "ds",
			change = "cs",
		},
	})
end

return M
