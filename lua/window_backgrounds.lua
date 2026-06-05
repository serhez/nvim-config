local M = {}

local dark_bg_groups = {
	Normal = "UserDarkBgWindow",
	NormalNC = "UserDarkBgWindow",
	NormalFloat = "UserDarkBgWindow",
	EndOfBuffer = "UserDarkBgWindow",
	SignColumn = "UserDarkBgWindow",
	FoldColumn = "UserDarkBgWindow",
}

local dark_bg_group_order = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"EndOfBuffer",
	"SignColumn",
	"FoldColumn",
}

function M.set_highlights()
	local colors = require("highlights").colors()
	local bg = colors.statusline_bg
	local fg = colors.fg
	local dim = colors.line_nr or colors.dim

	vim.api.nvim_set_hl(0, "UserDarkBgWindow", { fg = fg, bg = bg })

	vim.api.nvim_set_hl(0, "NeogitNormal", { fg = fg, bg = bg })
	vim.api.nvim_set_hl(0, "NeogitNormalFloat", { fg = fg, bg = bg })
	vim.api.nvim_set_hl(0, "NeogitFloatBorder", { fg = dim, bg = bg })
	vim.api.nvim_set_hl(0, "NeogitSignColumn", { fg = dim, bg = bg })
	vim.api.nvim_set_hl(0, "NeogitFold", { fg = dim, bg = bg })
	vim.api.nvim_set_hl(0, "NeogitFoldColumn", { fg = dim, bg = bg })
end

function M.apply_dark_bg(winid)
	winid = winid or vim.api.nvim_get_current_win()
	if not vim.api.nvim_win_is_valid(winid) then
		return
	end

	local existing = vim.wo[winid].winhighlight or ""
	local order = {}
	local groups = {}

	for item in existing:gmatch("[^,]+") do
		local from, to = item:match("^%s*([^:]+):(.+)%s*$")
		if from and to and from ~= "" and to ~= "" then
			if not groups[from] then
				table.insert(order, from)
			end
			groups[from] = to
		end
	end

	for _, from in ipairs(dark_bg_group_order) do
		if not groups[from] then
			table.insert(order, from)
		end
		groups[from] = dark_bg_groups[from]
	end

	local winhighlight = {}
	for _, from in ipairs(order) do
		if groups[from] then
			table.insert(winhighlight, from .. ":" .. groups[from])
		end
	end

	vim.wo[winid].winhighlight = table.concat(winhighlight, ",")
end

local function matches_filetype(filetype, patterns)
	for _, pattern in ipairs(patterns) do
		if pattern:sub(-1) == "*" then
			if filetype:sub(1, #pattern - 1) == pattern:sub(1, -2) then
				return true
			end
		elseif filetype == pattern then
			return true
		end
	end

	return false
end

local function apply_for_buffer(bufnr, patterns)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	if not matches_filetype(vim.bo[bufnr].filetype, patterns) then
		return
	end

	for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
		M.apply_dark_bg(winid)
	end
end

function M.setup_dark_bg_filetypes(group_name, patterns)
	M.set_highlights()

	local group = vim.api.nvim_create_augroup(group_name, { clear = true })

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = M.set_highlights,
	})

	vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
		group = group,
		callback = function(args)
			apply_for_buffer(args.buf or vim.api.nvim_get_current_buf(), patterns)
		end,
	})

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		apply_for_buffer(bufnr, patterns)
	end
end

return M
