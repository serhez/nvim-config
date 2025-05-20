local M = {
	"yetone/avante.nvim",
	build = "make",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
	},
}

function M.init()
	require("mappings").register({
		{
			"<leader>aa",
			function()
				require("avante.api").ask()
			end,
			desc = "Ask",
			mode = { "n", "v" },
		},
		{
			"<leader>ae",
			function()
				require("avante.api").edit()
			end,
			desc = "Edit",
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
			"<leader>ah",
			function()
				require("avante.toggle").hint()
			end,
			desc = "Toggle hints",
			mode = { "n", "v" },
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
			"<leader>am",
			function()
				require("avante.model_selector").open()
			end,
			desc = "Select model",
		},
	})
end

function M.config()
	require("avante_lib").load()
	require("avante").setup({
		---@alias Provider "openai" | "claude" | "azure"  | "copilot" | [string]
		provider = "copilot",
		auto_suggestions_provider = "copilot",
		-- provider = "claude",
		-- auto_suggestions_provider = "claude",
		copilot = {
			-- model = "gpt-4o",
			model = "claude-3.5-sonnet",
		},
		behaviour = {
			auto_set_keymaps = false,
		},
		mappings = {
			ask = "<nop>",
			edit = "<nop>",
			refresh = "<nop>",
			diff = {
				ours = "co",
				theirs = "ct",
				none = "c0",
				both = "cb",
				next = "]x",
				prev = "[x",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			toggle = {
				debug = "<nop>",
				hint = "<leader>ah",
				default = "<nop>",
			},
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
				remove_file = "d",
				add_file = "@",
			},
		},
		hints = { enabled = true },
		windows = {
			wrap = true, -- similar to vim.o.wrap
			width = 33, -- default % based on available width
			sidebar_header = {
				align = "center", -- left, center, right for title
				rounded = false,
			},
		},
		diff = {
			debug = false,
			autojump = true,
			list_opener = "copen",
		},
	})
end

return M
