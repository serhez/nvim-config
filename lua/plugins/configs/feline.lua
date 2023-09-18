local icons = require("icons")
local hls = require("highlights")

local M = {
	"freddiehaddad/feline.nvim",
	event = "VeryLazy",
}

M.venv = nil

M.set_venv = function(venv)
	local path = vim.split(venv, "/", { trimempty = true })
	M.venv = path[#path]
end

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

-- local function get_navic_location()
-- 	local navic_present, navic = pcall(require, "nvim-navic")
--
-- 	if not navic_present then
-- 		return ""
-- 	end
-- 	local location = navic.get_location()
-- 	if location == "" then
-- 		return location
-- 	else
-- 		return icons.single_space .. icons.arrow.right_tall .. icons.single_space .. location
-- 	end
-- end

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

local function file_path_provider(_, opts)
	local winnr = vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	local separator = opts.separator or icons.arrow.right_tall

	if vim.api.nvim_buf_get_name(bufnr) == "" then
		return ""
	end

	local filename = vim.api.nvim_buf_get_name(bufnr)
	local dirname = vim.fn.fnamemodify(filename, ":~:.:h")

	local str = ""

	if dirname == "." then
		return str
	end
	if dirname:sub(1, 1) == "/" then
		str = str .. "/"
	end

	local protocol_start_index = dirname:find("://")
	if protocol_start_index ~= nil then
		local protocol = dirname:sub(1, protocol_start_index + 2)
		str = str .. protocol
		dirname = dirname:sub(protocol_start_index + 3)
	end

	local dirs = vim.split(dirname, "/", { trimempty = true })
	for _, dir in ipairs(dirs) do
		str = str .. dir .. " " .. separator .. " "
	end

	return str
end

local function venv_provider()
	if M.venv == nil or M.venv == "" or M.venv == "base" then
		return ""
	end

	return icons.tool.venv .. " " .. M.venv .. " "
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
		venv = {
			provider = "venv",
			hl = "FlnText",
			right_sep = { str = icons.single_space, hl = "FlnSep" },
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
				icon = " " .. icons.git.added .. " ",
				hl = "FlnGreen",
			},
			change = {
				provider = "git_diff_changed",
				icon = " " .. icons.git.changed .. " ",
				hl = "FlnYellow",
			},
			remove = {
				provider = "git_diff_removed",
				icon = " " .. icons.git.removed .. " ",
				hl = "FlnRed",
			},
		},
		file_path = {
			provider = {
				name = "file_path",
				opts = {
					separator = icons.arrow.right_tall,
				},
			},
			hl = "FlnDimText",
			left_sep = { hl = "FlnSep" },
			right_sep = { hl = "FlnSep" },
		},
		file_info = {
			provider = {
				name = "file_info",
				opts = {
					type = "base-only",
					path_sep = " " .. icons.arrow.right_tall .. " ",
					file_readonly_icon = icons.lock .. icons.single_space,
					file_modified_icon = icons.small_circle,
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
		in_file_info = {
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
			components.venv,
			components.git.branch,
			components.git.add,
			components.git.change,
			components.git.remove,
		},
		{ -- center
			-- components.file_path,
			components.file_info,
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
		{ components.in_file_info }, -- center
		{ components.default }, -- right
	}

	-- local winbar_active = {
	--     { c.file_info },
	-- }

	require("feline").setup({
		components = { active = statusline_active, inactive = statusline_inactive },
		highlight_reset_triggers = {},
		custom_providers = {
			file_path = file_path_provider,
			venv = venv_provider,
		},
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

		FlnHint = { fg = c.hint_fg, bg = c.statusline_bg },
		FlnInfo = { fg = c.info_fg, bg = c.statusline_bg },
		FlnWarn = { fg = c.warn_fg, bg = c.statusline_bg },
		FlnError = { fg = c.error_fg, bg = c.statusline_bg },
		FlnStatus = { fg = c.statusline_fg, bg = c.statusline_bg, bold = true },

		FlnText = { fg = c.statusline_fg, bg = c.statusline_bg },
		FlnDimText = { fg = c.dim, bg = c.statusline_bg, italic = true },
		FlnBoldText = { fg = c.statusline_fg, bg = c.statusline_bg, bold = true },
		FlnSep = { fg = c.statusline_fg, bg = c.statusline_bg },
		FlnGitBranch = { fg = c.statusline_fg, bg = c.statusline_bg },
		FlnNavic = { fg = c.statusline_fg, bg = c.statusline_bg },
	})
end

return M
