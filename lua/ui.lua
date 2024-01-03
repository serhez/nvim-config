local M = {}

function M.setup()
	M.set_separators()

	-- Statuscolumn (for when plugin `statuscol` is buggy)
	-- vim.o.statuscolumn = "%@SignCb@%s%=%T%@NumCb@%r│%T"
end

function M.set_separators()
	local icons = require("icons")
	vim.o.fillchars = "vert:"
		.. icons.bar.vertical_block
		.. ",horiz:"
		.. icons.bar.lower_horizontal_thick
		.. ",horizup:"
		.. icons.bar.vertical_block
		.. ",horizdown:"
		.. icons.bar.vertical_block
		.. ",vertleft:"
		.. icons.bar.vertical_block
		.. ",vertright:"
		.. icons.bar.vertical_block
		.. ",verthoriz:"
		.. icons.bar.vertical_block
end

return M
