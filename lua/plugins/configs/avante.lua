local M = {
	"yetone/avante.nvim",
	build = "make",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
		"folke/snacks.nvim",
	},
}

function M.init()
	require("mappings").register({
		{
			"<leader>ac",
			function()
				require("avante.api").ask()
			end,
			desc = "Toggle chat",
			mode = { "n", "v" },
		},
		{
			"<leader>ae",
			function()
				require("avante.api").edit()
			end,
			desc = "Edit",
			mode = { "v" },
		},
		{
			"<leader>ah",
			function()
				require("avante.api").select_history()
			end,
			desc = "Chat history",
			mode = { "n" },
		},
		{
			"<leader>am",
			function()
				require("avante.model_selector").open()
			end,
			desc = "Select model",
		},
		{
			"<leader>aM",
			function()
				require("avante.repo_map").show()
			end,
			desc = "Repository map",
		},
		{
			"<leader>an",
			function()
				require("avante.api").ask({ new_chat = true })
			end,
			desc = "New chat",
			mode = { "n", "v" },
		},
		{
			"<leader>ap",
			":AvanteSwitchProvider ",
			desc = "Select provider",
		},
		{
			"<leader>aq",
			function()
				require("avante.diff").conflicts_to_qf_items(function(items)
					if #items > 0 then
						vim.fn.setqflist(items, "r")
						vim.cmd("copen")
					end
				end)
			end,
			desc = "Conficts to quickfix",
			mode = { "n", "v" },
		},
		{
			"<leader>ar",
			function()
				require("avante.api").refresh()
			end,
			desc = "Refresh",
			mode = { "n", "v" },
		},
		{
			"<leader>aS",
			function()
				require("avante.api").stop()
			end,
			desc = "Stop generation",
		},
	})
end

function M.config()
	local icons = require("icons")

	-- TODO: open issue in avante to integrate with the snacks explorer
	-- local snacks_sources = require("snacks.picker.config.sources")

	require("avante_lib").load()
	require("avante").setup({
		---@alias Provider "openai" | "claude" | "azure"  | "copilot" | [string]
		provider = "copilot",
		auto_suggestions_provider = "copilot",
		-- providers = {
		-- 	copilot = {
		-- 		model = "claude-sonnet-4",
		-- 	},
		-- },
		behaviour = {
			auto_set_keymaps = false,
			auto_approve_tool_permissions = false,
			---@type "popup" | "inline_buttons"
			confirmation_ui_style = "inline_buttons",
		},
		input = {
			provider = "snacks",
			provider_opts = {
				title = "Avante",
				icon = icons.AI,
				layout = {
					preset = function()
						return vim.o.columns >= 120 and "ivy" or "vscode"
					end,
				},
			},
		},
		selector = {
			provider = "snacks",
			-- provider_opts = snacks_sources.explorer,
			provider_opts = {
				title = "Avante",
				icon = icons.AI,
				layout = {
					preset = function()
						return vim.o.columns >= 120 and "ivy" or "vscode"
					end,
				},
			},
		},
		mappings = {
			files = {
				add_current = "aC", -- conflicts with current toggle chat mapping
			},
		},
		windows = {
			wrap = true, -- similar to vim.o.wrap
			width = 33, -- default % based on available width
			sidebar_header = {
				align = "center", -- left, center, right for title
				rounded = false,
			},
		},
	})
end

return M
