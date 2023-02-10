local icons = require("icons")
local hls = require("highlights")

local M = {
	"feline-nvim/feline.nvim",
	event = "VeryLazy",
}

local vi_colors = {
	n = "FlnViCyan",
	no = "FlnViCyan",
	i = "FlnStatus",
	v = "FlnViMagenta",
	V = "FlnViMagenta",
	[""] = "FlnViMagenta",
	R = "FlnViRed",
	Rv = "FlnViRed",
	r = "FlnViBlue",
	rm = "FlnViBlue",
	s = "FlnViMagenta",
	S = "FlnViMagenta",
	[""] = "FelnMagenta",
	c = "FlnViYellow",
	["!"] = "FlnViBlue",
	t = "FlnViBlue",
}

local function get_navic_location()
	local navic_present, navic = pcall(require, "nvim-navic")

	if not navic_present then
		return ""
	end
	local location = navic.get_location()
	if location == "" then
		return location
	else
		return icons.single_space .. icons.arrow.right_short .. icons.single_space .. location
	end
end

local function vi_mode_hl()
	return vi_colors[vim.fn.mode()] or "FlnViBlack"
end

local function lsp_diagnostics_info()
	local lsp = require("feline.providers.lsp")

	return {
		error = lsp.get_diagnostics_count("ERROR"),
		warning = lsp.get_diagnostics_count("WARN"),
		info = lsp.get_diagnostics_count("INFO"),
		hint = lsp.get_diagnostics_count("HINT"),
	}
end

local function lsp_diagnostics_show(severity)
	return function()
		return require("feline.providers.lsp").diagnostics_exist(severity)
	end
end

local function diag_of(f, s)
	local icon = icons.diagnostics[s]
	return function()
		local diag = f()[s]
		return icon .. icons.single_space .. diag
	end
end

function M.config()
	-- local navic_present, navic = pcall(require, "nvim-navic")

	local components = {
		default = { -- needed to pass the parent StatusLine hl group to right hand side
			provider = "",
			hl = "StatusLine",
		},
		vimode = {
			left = {
				provider = icons.double_space,
				hl = vi_mode_hl,
				right_sep = { str = icons.double_space, hl = "FlnSep" },
			},
			right = {
				provider = icons.double_space,
				hl = vi_mode_hl,
				left_sep = { str = icons.double_space, hl = "FlnSep" },
			},
		},
		git = {
			branch = {
				provider = "git_branch",
				icon = icons.git.branch .. icons.single_space,
				hl = "FlnGitBranch",
				right_sep = { str = icons.single_space, hl = "FlnSep" },
				enabled = function()
					return vim.b.gitsigns_status_dict ~= nil
				end,
			},
			add = {
				provider = "git_diff_added",
				hl = "FlnGreen",
			},
			change = {
				provider = "git_diff_changed",
				hl = "FlnYellow",
			},
			remove = {
				provider = "git_diff_removed",
				hl = "FlnRed",
			},
		},
		fileinfo = {
			provider = {
				name = "file_info",
				opts = {
					type = "unique",
					file_readonly_icon = icons.lock .. icons.single_space,
				},
			},
			hl = "FlnBoldText",
			left_sep = { hl = "FlnSep" },
			right_sep = { hl = "FlnSep" },
		},
		diagnostics = {
			error = {
				provider = diag_of(lsp_diagnostics_info, "error"),
				enabled = lsp_diagnostics_show("ERROR"),
				hl = "FlnError",
			},
			warning = {
				provider = diag_of(lsp_diagnostics_info, "warning"),
				enabled = lsp_diagnostics_show("WARN"),
				left_sep = { str = icons.single_space, hl = "FlnSep" },
				hl = "FlnWarn",
			},
			info = {
				provider = diag_of(lsp_diagnostics_info, "info"),
				enabled = lsp_diagnostics_show("INFO"),
				left_sep = { str = icons.single_space, hl = "FlnSep" },
				hl = "FlnInfo",
			},
			hint = {
				provider = diag_of(lsp_diagnostics_info, "hint"),
				enabled = lsp_diagnostics_show("HINT"),
				left_sep = { str = icons.single_space, hl = "FlnSep" },
				hl = "FlnHint",
			},
		},
		cursor = {
			position = {
				provider = "position",
				hl = "FlnText",
				left_sep = { str = icons.double_space, hl = "FlnSep" },
			},
			percentage = {
				provider = "line_percentage",
				left_sep = { str = icons.double_space, hl = "FlnSep" },
				hl = "FlnText",
			},
		},
		in_fileinfo = {
			provider = {
				name = "file_info",
				opts = {
					type = "relative",
					file_readonly_icon = icons.lock .. icons.single_space,
				},
			},
			hl = "StatusLine",
			left_sep = { hl = "FlnSep" },
			right_sep = { hl = "FlnSep" },
		},
	}

	-- if navic_present then
	-- 	components.navic = {
	-- 		provider = function()
	-- 			return get_navic_location()
	-- 		end,
	-- 		enabled = function()
	-- 			return navic.is_available()
	-- 		end,
	-- 		hl = "FlnNavic",
	-- 	}
	-- end

	local statusline_active = {
		{ -- left
			components.vimode.left,
			components.git.branch,
			components.git.add,
			components.git.change,
			components.git.remove,
		},
		{ -- center
			components.fileinfo,
		},
		{ -- right
			components.diagnostics.error,
			components.diagnostics.warning,
			components.diagnostics.info,
			components.diagnostics.hint,
			components.cursor.position,
			components.cursor.percentage,
			components.vimode.right,
		},
	}

	-- if navic_present then
	-- 	table.insert(statusline_active[2], components.navic)
	-- end

	local statusline_inactive = {
		{ components.default }, -- left
		{ components.in_fileinfo }, -- center
		{ components.default }, -- right
	}

	-- local winbar_active = {
	--     { c.fileinfo },
	-- }

	require("feline").setup({
		components = { active = statusline_active, inactive = statusline_inactive },
		highlight_reset_triggers = {},
		force_inactive = {
			filetypes = {
				"help",
			},
			buftypes = { "terminal" },
			bufnames = {},
		},
		disable = {
			filetypes = {
				"dap-repl",
				"dapui_scopes",
				"dapui_stacks",
				"dapui_watches",
				"dapui_repl",
				"LspTrouble",
				"qf",
				"NvimTree",
				"vista_kind",
				"dashboard",
				"startify",
			},
		},
	})

	-- require("feline").winbar.setup()

	local c = hls.colors()
	hls.register_hls({
		FlnViBlack = { fg = c.white, bg = c.black, bold = true },
		FlnViRed = { fg = c.statusline_bg, bg = c.red, bold = true },
		FlnViGreen = { fg = c.statusline_bg, bg = c.green, bold = true },
		FlnViYellow = { fg = c.statusline_bg, bg = c.yellow, bold = true },
		FlnViBlue = { fg = c.statusline_bg, bg = c.blue, bold = true },
		FlnViMagenta = { fg = c.statusline_bg, bg = c.magenta, bold = true },
		FlnViCyan = { fg = c.statusline_bg, bg = c.cyan, bold = true },
		FlnViWhite = { fg = c.statusline_bg, bg = c.white, bold = true },

		FlnBlack = { fg = c.black, bg = c.white },
		FlnRed = { fg = c.red, bg = c.statusline_bg },
		FlnGreen = { fg = c.green, bg = c.statusline_bg },
		FlnYellow = { fg = c.yellow, bg = c.statusline_bg },
		FlnBlue = { fg = c.blue, bg = c.statusline_bg },
		FlnMagenta = { fg = c.magenta, bg = c.statusline_bg },
		FlnCyan = { fg = c.cyan, bg = c.statusline_bg },
		FlnWhite = { fg = c.white, bg = c.statusline_bg },

		FlnHint = { fg = c.hint, bg = c.statusline_bg },
		FlnInfo = { fg = c.info, bg = c.statusline_bg },
		FlnWarn = { fg = c.warn, bg = c.statusline_bg },
		FlnError = { fg = c.error, bg = c.statusline_bg },
		FlnStatus = { fg = c.statusline_fg, bg = c.statusline_bg, bold = true },

		FlnText = { fg = c.statusline_fg, bg = c.statusline_bg },
		FlnBoldText = { fg = c.statusline_fg, bg = c.statusline_bg, bold = true },
		FlnSep = { fg = c.statusline_fg, bg = c.statusline_bg },
		FlnGitBranch = { fg = c.statusline_fg, bg = c.statusline_bg },
		FlnNavic = { fg = c.statusline_fg, bg = c.statusline_bg },
	})
end

return M
