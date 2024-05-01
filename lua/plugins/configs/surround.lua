local M = {
	"kylechui/nvim-surround",
	event = "InsertEnter",
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
			visual = "S",
			visual_line = "gS",
			delete = "ds",
			change = "cs",
		},
	})
end

return M
