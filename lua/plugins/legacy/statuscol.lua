local icons = require("icons")

local M = {
	"luukvbaal/statuscol.nvim",
	event = "VeryLazy",
}

function M.config()
	require("statuscol").setup({
		separator = icons.bar.vertical_center_thin, -- separator between line number and buffer text ("│" or extra " " padding)
		-- Builtin line number string options for ScLn() segment
		thousands = false, -- or line number thousands separator string ("." / ",")
		relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
		-- Builtin 'statuscolumn' options
		setopt = true, -- whether to set the 'statuscolumn', providing builtin click actions
		order = "FSNs", -- order of the fold, sign, line number and separator segments
	})
end

return M
