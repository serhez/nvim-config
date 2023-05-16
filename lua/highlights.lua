-- NOTE: You can discover all highlight groups by executing ':hi'
-- TODO: Redefine DAP UI colours (these ones: https://github.com/rcarriga/nvim-dap-ui/blob/master/lua/dapui/config/highlights.lua)

local M = {}

-- Autogenerated highlight groups based on current colorscheme

function M.fromhl(hl)
	local result = {}
	local list = vim.api.nvim_get_hl_by_name(hl, true)
	for k, v in pairs(list) do
		local status, res = pcall(string.format, "#%06x", v)
		if status then
			local name = k == "background" and "bg" or "fg"
			result[name] = res
		end
	end
	return result
end

local function term(num, default)
	local key = "terminal_color_" .. num
	return vim.g[key] and vim.g[key] or default
end

function M.colors()
	return {
		bg = M.fromhl("Normal").bg,
		fg = M.fromhl("Normal").fg,
		dim = M.fromhl("Conceal").fg,
		statusline_bg = M.fromhl("StatusLine").bg,
		statusline_fg = M.fromhl("StatusLine").fg,
		cursor_line_bg = M.fromhl("CursorLine").bg,
		cursor_line_fg = M.fromhl("CursorLine").fg,
		line_nr = M.fromhl("LineNr").fg,
		hint_fg = M.fromhl("DiagnosticHint").fg,
		hint_bg = M.fromhl("DiagnosticHint").bg,
		info_fg = M.fromhl("DiagnosticInfo").fg,
		info_bg = M.fromhl("DiagnosticInfo").bg,
		warn_fg = M.fromhl("DiagnosticWarn").fg,
		warn_bg = M.fromhl("DiagnosticWarn").bg,
		error_fg = M.fromhl("DiagnosticError").fg,
		error_bg = M.fromhl("DiagnosticError").bg,
		identifier_fg = M.fromhl("Identifier").fg,
		identifier_bg = M.fromhl("Identifier").bg,
		black = term(0, "#434C5E"),
		red = term(1, "#EC5F67"),
		green = term(2, "#8FBCBB"),
		yellow = term(3, "#EBCB8B"),
		blue = term(4, "#5E81AC"),
		magenta = term(5, "#B48EAD"),
		cyan = term(6, "#88C0D0"),
		white = term(7, "#ECEFF4"),
	}
end

function M.common_hls()
	local colors = M.colors()

	return {
		border_dim = { fg = colors.line_nr, bg = colors.dim },
		border_statusline = { fg = colors.line_nr, bg = colors.statusline_bg },
		border_alt = { fg = colors.line_nr, bg = colors.cursor_line_bg },
		no_border_dim = { fg = colors.dim, bg = colors.dim },
		no_border_statusline = { fg = colors.statusline_bg, bg = colors.statusline_bg },
		no_border_alt = { fg = colors.cursor_line_bg, bg = colors.cursor_line_bg },
	}
end

function M.register_hls(groups)
	for k, v in pairs(groups) do
		vim.api.nvim_set_hl(0, k, v)
	end
end

-- This function must be called on an autocmd when the colorscheme is changed
-- After the function is called, UI components using these highlight groups must also be reloaded
function M.setup()
	-- Catppuccin
	vim.g.catppuccin_flavour = "macchiato"

	-- Github
	vim.g.github_function_style = "italic"
	vim.g.github_sidebars = { "qf", "vista_kind", "terminal" }

	-- Tokyonight
	vim.g.tokyonight_italic_functions = true
	vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal" }

	-- Colorscheme
	vim.g.nvcode_termcolors = 256
	vim.g.syntax = true
	vim.g.colors_name = "catppuccin-latte"
	vim.o.background = "light"

	-- Remove the tilde (~) after EOF
	vim.cmd([[let &fcs='eob: ']])

	local common_hls = M.common_hls()
	local c = M.colors()
	local groups = {
		-- Native UI
		FloatBorder = common_hls.no_border_statusline,
		NormalFloat = { bg = c.statusline_bg },
		DiagnosticUnderlineError = { undercurl = true, sp = c.error_fg },
		DiagnosticUnderlineWarn = { undercurl = true, sp = c.warn_fg },
		DiagnosticUnderlineHint = { undercurl = true, sp = c.hint_fg },
		DiagnosticUnderlineInfo = { undercurl = true, sp = c.info_fg },

		-- End of buffer
		NonText = { default = true, link = "LineNr" },
		EndOfBuffer = { default = true, link = "Normal" },

		-- LSP
		LspFloatWinNormal = { bg = c.statusline_bg },
		LspFloatWinBorder = common_hls.no_border_statusline,
		DiagnosticFloatingError = { fg = c.error_fg, bg = c.statusline_bg },
		DiagnosticFloatingWarn = { fg = c.warn_fg, bg = c.statusline_bg },
		DiagnosticFloatingInfo = { fg = c.info_fg, bg = c.statusline_bg },
		DiagnosticFloatingHint = { fg = c.hint_fg, bg = c.statusline_bg },
	}

	M.register_hls(groups)
end

return M
