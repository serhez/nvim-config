local M = {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	event = { "BufReadPost", "BufNewFile" },
}

function M.init()
	local grapple = require("grapple")
	local cybu_present, _ = pcall(require, "cybu")

	vim.keymap.set("n", "<Tab>", function()
		if not grapple.exists() then
			vim.cmd("Bwipeout")
		end
		if cybu_present then
			vim.cmd("CybuNext")
		else
			grapple.cycle_forward()
		end
	end)
	vim.keymap.set("n", "<S-Tab>", function()
		if not grapple.exists() then
			vim.cmd("Bwipeout")
		end
		if cybu_present then
			vim.cmd("CybuPrev")
		else
			grapple.cycle_backward()
		end
	end)

	require("mappings").register_normal({
		t = { grapple.toggle, "Tag file" },
		T = { grapple.toggle_tags, "Tagged files" },
	})

	vim.keymap.set({ "n", "x", "o" }, "t", grapple.toggle_tags, { desc = "Tags list" })
end

function M.config()
	require("grapple").setup({
		---Default scope to use when managing Grapple tags
		---For more information, please see the Scopes section
		---@type string
		scope = "git_branch",

		---Show icons next to tags or scopes in Grapple windows
		---Requires "nvim-tree/nvim-web-devicons"
		---@type boolean
		icons = true,

		---Highlight the current selection in Grapple windows
		---Also, indicates when a tag path does not exist
		---@type boolean
		status = true,

		---Position a tag's name should be shown in Grapple windows
		---@type "start" | "end"
		name_pos = "end",

		---How a tag's path should be rendered in Grapple windows
		---  "relative": show tag path relative to the scope's resolved path
		---  "basename": show tag path basename and directory hint
		---@type "basename" | "relative"
		style = "relative",

		---A string of characters used for quick selecting in Grapple windows
		---An empty string or false will disable quick select
		---@type string | nil
		quick_select = "123456789",

		---Default command to use when selecting a tag
		---@type fun(path: string)
		command = vim.cmd.edit,

		---Additional window options for Grapple windows
		---See :h nvim_open_win
		---@type grapple.vim.win_opts
		win_opts = {
			-- Can be fractional
			width = 80,
			height = 12,
			row = 0.5,
			col = 0.5,

			relative = "editor",
			border = "solid",
			focusable = false,
			style = "minimal",
			title_pos = "center",

			-- Custom: fallback title for Grapple windows
			title = "Tags",

			-- Custom: adds padding around window title
			title_padding = "  ",
		},
	})
end

return M
