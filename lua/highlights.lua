-- NOTE: You can discover all highlight groups by executing ':hi'
-- TODO: Redefine DAP UI colours (these ones: https://github.com/rcarriga/nvim-dap-ui/blob/master/lua/dapui/config/highlights.lua)

local M = {}

-- Autogenerated highlight groups based on current colorscheme

local function fromhl(hl)
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
		bg = fromhl("Normal").bg,
		fg = fromhl("Normal").fg,
		alt_bg = fromhl("CursorLine").bg,
		alt_fg = fromhl("CursorLine").bg,
		statusline_bg = fromhl("StatusLine").bg,
		statusline_fg = fromhl("StatusLine").fg,
		dim = fromhl("Conceal").fg,
		hint = fromhl("DiagnosticHint").fg or "#5E81AC",
		info = fromhl("DiagnosticInfo").fg or "#81A1C1",
		warn = fromhl("DiagnosticWarn").fg or "#EBCB8B",
		error = fromhl("DiagnosticError").fg or "#EC5F67",
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
		border = { fg = colors.cyan, bg = colors.statusline_bg },
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
	vim.g.catppuccin_flavour = "mocha"

	-- Github
	vim.g.github_function_style = "italic"
	vim.g.github_sidebars = { "qf", "vista_kind", "terminal" }

	-- Tokyonight
	vim.g.tokyonight_italic_functions = true
	vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal" }

	-- Colorscheme
	vim.g.nvcode_termcolors = 256
	vim.g.syntax = true
	vim.g.colors_name = "tokyonight-storm"
	vim.o.background = "dark"

	-- Remove the tilde (~) after EOF
	vim.cmd([[let &fcs='eob: ']])

	local common_c = M.common_hls()
	local c = M.colors()

	local groups = {
		-- Native UI
		FloatBorder = common_c.border,
		NormalFloat = { bg = c.statusline_bg },
		DiagnosticUnderlineError = { undercurl = true, sp = c.error },
		DiagnosticUnderlineWarn = { undercurl = true, sp = c.warn },
		DiagnosticUnderlineHint = { undercurl = true, sp = c.hint },
		DiagnosticUnderlineInfo = { undercurl = true, sp = c.info },

		-- End of buffer
		NonText = { default = true, link = "LineNr" },
		EndOfBuffer = { default = true, link = "Normal" },

		-- LSP
		LspFloatWinNormal = { bg = c.statusline_bg },
		LspFloatWinBorder = common_c.border,
		DiagnosticFloatingError = { fg = c.error, bg = c.statusline_bg },
		DiagnosticFloatingWarn = { fg = c.warn, bg = c.statusline_bg },
		DiagnosticFloatingInfo = { fg = c.info, bg = c.statusline_bg },
		DiagnosticFloatingHint = { fg = c.hint, bg = c.statusline_bg },
	}

	M.register_hls(groups)
end

return M
