local icons = require("icons")

local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

M.venv = nil
M.show_filetype = false

function M.set_venv(venv)
	local path = vim.split(venv, "/", { trimempty = true })
	M.venv = path[#path]
end

function M.toggle_filetype()
	M.show_filetype = not M.show_filetype
end

local function venv_provider()
	if M.venv == nil or M.venv == "" or M.venv == "base" then
		return ""
	end

	return icons.tool.venv .. " " .. M.venv
end

local function kernel_provider()
	if package.loaded.molten then
		local present, molten_status = pcall(require, "molten.status")
		if present and molten_status.initialized() == "Molten" then
			local kernels = molten_status.kernels()

			if kernels == nil or kernels == "" then
				return ""
			end

			return icons.tool.kernel .. " " .. kernels
		end
	end

	return ""
end

local function pinned_provider()
	return icons.hook
end

local function pinned_condition()
	local present, grapple = pcall(require, "grapple")
	if not present then
		return false
	end
	return grapple.exists()
end

local function recorder_provider()
	return icons.camera .. " Rec"
end

local function recorder_condition()
	local present, recorder = pcall(require, "recorder")
	if not present then
		return false
	end
	return recorder.recordingStatus() ~= ""
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		u = {
			f = { "<cmd>lua require('plugins.configs.lualine').toggle_filetype()<cr>", "Toggle filetype" },
		},
	})
end

function M.config()
	local colors = require("highlights").colors()

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {
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
				winbar = { "*" },
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
		},
		sections = {
			-- lualine_a = {
			-- 	{
			-- 		"mode",
			-- 		padding = 0,
			-- 		fmt = function(_)
			-- 			return "   "
			-- 		end,
			-- 	},
			-- },
			lualine_a = {
				{
					venv_provider,
					cond = function()
						return M.venv ~= nil and M.venv ~= "" and M.venv ~= "base"
					end,
					on_click = function(_, _, _)
						vim.cmd("lua require('swenv.api').pick_venv()")
					end,
				},
				{
					kernel_provider,
				},
				{
					"branch",
					icon = icons.git.branch,
					on_click = function(_, _, _)
						vim.cmd("Telescope git_branches theme=ivy")
					end,
				},
				{
					"diff",
					colored = true,
					padding = { left = 0, right = 1 },
					diff_color = {
						-- NOTE: These highlights depend on `neogit`
						added = "NeogitDiffAddHighlight",
						modified = "NeogitHunkHeaderHighlight",
						removed = "NeogitDiffDeleteHighlight",
					},
					symbols = {
						added = " " .. icons.git.added .. " ",
						modified = " " .. icons.git.changed .. " ",
						removed = " " .. icons.git.removed .. " ",
					},
					source = diff_source,
					on_click = function(_, _, _)
						vim.cmd("DiffviewOpen")
					end,
				},
			},
			lualine_b = {},
			lualine_c = {
				"%=",
				{
					"hostname",
					cond = function()
						return not string.find(vim.loop.os_gethostname(), "local")
							and not string.find(vim.loop.os_gethostname(), "home")
					end,
				},
				{
					"filetype",
					icon_only = true,
					separator = "",
					padding = { left = 0, right = 0 },
				},
				{
					"filename",
					file_status = true,
					newfile_status = false,
					path = 0,
					padding = { left = 1, right = 2 },
					shorting_target = 40,
					color = { gui = "bold" },
					symbols = {
						modified = icons.small_circle,
						readonly = icons.lock,
						unnamed = "[No Name]",
						newfile = "[New]",
					},
				},
				{
					pinned_provider,
					cond = pinned_condition,
					padding = { left = 0, right = 0 },
					color = { fg = colors.yellow },
				},
			},
			lualine_x = {},
			lualine_y = {
				{
					"diagnostics",
					sources = { "nvim_lsp" },
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						error = "DiagnosticVirtualTextError",
						warn = "DiagnosticVirtualTextWarn",
						info = "DiagnosticVirtualTextInfo",
						hint = "DiagnosticVirtualTextHint",
					},
					symbols = {
						error = icons.diagnostics.error .. " ",
						warn = icons.diagnostics.warning .. " ",
						info = icons.diagnostics.info .. " ",
						hint = icons.diagnostics.hint .. " ",
					},
					colored = true,
					update_in_insert = false,
					always_visible = false,
					on_click = function(_, _, _)
						vim.cmd("Trouble diagnostics toggle filter.buf=0")
					end,
				},
				{
					recorder_provider,
					cond = recorder_condition,
					color = "Error",
				},
				{
					"copilot",
					show_colors = false,
					show_loading = true,
					symbols = {
						status = {
							icons = {
								enabled = icons.copilot.enabled,
								sleep = icons.copilot.sleep,
								disabled = icons.copilot.disabled,
								warning = icons.copilot.warning,
								unknown = icons.copilot.unknown,
							},
						},
					},
				},
				{
					"filetype",
					icon = { "" },
					cond = function()
						return M.show_filetype
					end,
				},
			},
			lualine_z = {
				"location",
				"progress",
				{
					"tabs",
					use_mode_colors = true,
					show_modified_status = false,
				},
			},
			-- lualine_z = {
			-- 	{
			-- 		"mode",
			-- 		padding = 0,
			-- 		fmt = function(_)
			-- 			return "   "
			-- 		end,
			-- 	},
			-- },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {
			"lazy",
			"mason",
			"neo-tree",
			"nvim-dap-ui",
			"oil",
			"quickfix",
			"symbols-outline",
			"toggleterm",
			"trouble",
		},
	})
end

return M
