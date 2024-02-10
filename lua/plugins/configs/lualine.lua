local icons = require("icons")

local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
	local present, hbac_state = pcall(require, "hbac.state")
	if not present then
		return " "
	end

	local cur_buf = vim.api.nvim_get_current_buf()
	if hbac_state.is_pinned(cur_buf) then
		return icons.pin
	else
		return " "
	end
end

local function recorder_provider()
	local present, recorder = pcall(require, "recorder")
	if not present then
		return ""
	end

	if recorder.recordingStatus() ~= "" then
		return icons.camera .. " Rec"
	end
	return ""
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
			lualine_a = {
				{
					"mode",
					padding = 0,
					fmt = function(_)
						return "   "
					end,
				},
			},
			lualine_b = {
				{
					venv_provider,
					cond = function()
						return M.venv ~= nil and M.venv ~= "" and M.venv ~= "base"
					end,
				},
				{
					kernel_provider,
				},
				{
					"branch",
					icon = icons.git.branch,
				},
				{
					"diff",
					colored = true,
					diff_color = {
						-- NOTE: These highlights depend on `neogit`
						added = "NeogitDiffAdd",
						modified = "NeogitHunkHeaderHighlight",
						removed = "NeogitDiffDelete",
					},
					symbols = {
						added = " " .. icons.git.added .. " ",
						modified = " " .. icons.git.changed .. " ",
						removed = " " .. icons.git.removed .. " ",
					},
				},
			},
			lualine_c = {
				"%=",
				{
					"hostname",
					cond = function()
						return not string.find(vim.loop.os_gethostname(), "local")
					end,
				},
				{
					pinned_provider,
				},
				{
					"filetype",
					icon_only = true,
					separator = "",
					padding = 0,
				},
				{
					"filename",
					file_status = true,
					newfile_status = false,
					path = 0,
					shorting_target = 40,
					color = { gui = "bold" },
					symbols = {
						modified = icons.small_circle,
						readonly = icons.lock,
						unnamed = "[No Name]",
						newfile = "[New]",
					},
				},
			},
			lualine_x = {
				{
					recorder_provider,
					color = "Error",
				},
				{
					"filetype",
					icon = { "" },
					cond = function()
						return M.show_filetype
					end,
				},
				{
					"diagnostics",
					sources = { "nvim_lsp", "nvim_diagnostic" },
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
				},
			},
			lualine_y = {
				"location",
				"progress",
				{
					"tabs",
					use_mode_colors = true,
					show_modified_status = false,
				},
			},
			lualine_z = {
				{
					"mode",
					padding = 0,
					fmt = function(_)
						return "   "
					end,
				},
			},
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
		extensions = {},
	})
end

return M
