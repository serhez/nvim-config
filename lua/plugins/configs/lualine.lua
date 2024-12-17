local icons = require("icons")

local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
	lazy = false,
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

local function supermaven_provider()
	local present, _ = pcall(require, "supermaven-nvim")
	if not present then
		return icons.copilot.unknown
	end
	if require("supermaven-nvim.api").is_running() then
		return icons.copilot.enabled
	end
	return icons.copilot.sleep
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
	return icons.pin_location
end

local function pinned_condition()
	local hbac_present, hbac = pcall(require, "hbac.state")
	if hbac_present then
		return hbac.is_pinned(vim.api.nvim_get_current_buf())
	end
	local grapple_present, grapple = pcall(require, "grapple")
	if not grapple_present then
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
	require("mappings").register({
		"<leader>Uf",
		"<cmd>lua require('plugins.configs.lualine').toggle_filetype()<cr>",
		desc = "Toggle filetype",
	})
end

function M.config()
	local hls = require("highlights")
	local colors = hls.colors()

	local custom_fname = require("lualine.components.filename"):extend()

	function custom_fname:init(options)
		custom_fname.super.init(self, options)

		-- Register highlight groups
		vim.api.nvim_set_hl(0, "LualineFileNameSaved", {
			link = "StatusLine",
		})
		vim.api.nvim_set_hl(0, "LualineFileNameModified", {
			link = "DiagnosticVirtualTextWarn",
		})

		if self.options.color == nil then
			self.options.color = ""
		end
	end

	function custom_fname:update_status()
		local data = custom_fname.super.update_status(self)
		data = "%#" .. (vim.bo.modified and "LualineFileNameModified" or "LualineFileNameSaved") .. "#" .. data
		return data
	end

	local custom_ftype = require("lualine.components.filetype"):extend()

	function custom_ftype:init(options)
		custom_ftype.super.init(self, options)

		-- Register highlight groups
		vim.api.nvim_set_hl(0, "LualineFileNameSaved", {
			link = "StatusLine",
		})
		vim.api.nvim_set_hl(0, "LualineFileNameModified", {
			link = "DiagnosticVirtualTextWarn",
		})

		if self.options.color == nil then
			self.options.color = ""
		end
	end

	function custom_ftype:update_status()
		local data = custom_ftype.super.update_status(self)
		data = "%#" .. (vim.bo.modified and "LualineFileNameModified" or "LualineFileNameSaved") .. "#" .. data
		return data
	end

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
				statusline = 100,
				tabline = 100,
				winbar = 100,
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
					pinned_provider,
					cond = pinned_condition,
					padding = { left = 1, right = 1 },
					color = { fg = colors.red },
				},
				{
					custom_ftype,
					icon_only = true,
					separator = "",
					padding = { left = 0, right = 0 },
				},
				{
					custom_fname,
					file_status = true,
					newfile_status = false,
					-- 0: Just the filename
					-- 1: Relative path
					-- 2: Absolute path
					-- 3: Absolute path, with tilde as the home directory
					-- 4: Filename and parent dir, with tilde as the home directory
					path = 0,
					padding = { left = 0, right = 1 },
					shorting_target = 100,
					color = { gui = "bold" },
					symbols = {
						modified = icons.small_circle,
						readonly = icons.lock,
						unnamed = "[No name]",
						newfile = "[New]",
					},
				},
			},
			lualine_x = {},
			lualine_y = {
				{
					function()
						return require("nvim-lightbulb").get_status_text()
					end,
					color = "DiagnosticVirtualTextInfo",
				},
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
					show_colors = true,
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
					cond = function()
						local present, _ = pcall(require, "copilot")
						return present
					end,
				},
				{
					supermaven_provider,
					cond = function()
						local present, _ = pcall(require, "supermaven-nvim")
						return present
					end,
					padding = { left = 1, right = 1 },
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
