local M = {}

function M.setup()
	M.set_separators()

	-- Statuscolumn (for when plugin `statuscol` is buggy)
	-- local present, _ = pcall(require, "statuscol")
	-- if not present then
	-- vim.opt.statuscolumn = [[%!v:lua.require('ui').statuscolumn()]]
	-- end
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

function M.statuscolumn()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local is_file = vim.bo[buf].buftype == ""
	local show_signs = vim.wo[win].signcolumn ~= "no"

	local components = { "", "", "" } -- left, middle, right

	if show_signs then
		---@type Sign?,Sign?,Sign?
		local left, right, fold
		for _, s in ipairs(M.get_signs(buf, vim.v.lnum)) do
			if s.name and s.name:find("GitSign") then
				right = s
			else
				left = s
			end
		end
		if vim.v.virtnum ~= 0 then
			left = nil
		end
		vim.api.nvim_win_call(win, function()
			if vim.fn.foldclosed(vim.v.lnum) >= 0 then
				fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded" }
			end
		end)
		-- Left: mark or non-git sign
		components[1] = M.icon(M.get_mark(buf, vim.v.lnum) or left)
		-- Right: fold icon or git sign (only if file)
		components[3] = is_file and M.icon(fold or right) or ""
	end

	-- Numbers in Neovim are weird
	-- They show when either number or relativenumber is true
	local is_num = vim.wo[win].number
	local is_relnum = vim.wo[win].relativenumber
	if (is_num or is_relnum) and vim.v.virtnum == 0 then
		if vim.v.relnum == 0 then
			components[2] = is_num and "%l" or "%r" -- the current line
		else
			components[2] = is_relnum and "%r" or "%l" -- other lines
		end
		components[2] = "%=" .. components[2] .. " " -- right align
	end

	return table.concat(components, "")
end

return M
