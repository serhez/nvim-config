local M = {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	ft = { "markdown" },
	cmd = {
		"ObsidianToday",
		"ObsidianYesterday",
		"ObsidianBacklinks",
		"ObsidianOpen",
		"ObsidianNew",
		"ObsidianSearch",
		"ObsidianQuickSwitch",
		"ObsidianLink",
		"ObsidianLinkNew",
		"ObsidianFollowLink",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	require("mappings").register({
		{
			"gl",
			function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "<cmd>ObsidianFollowLink<CR>"
				else
					return "gl"
				end
			end,
			desc = "Follow link",
		},

		{ "<leader>o", group = "Obsidian" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
		{ "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find notes" },
		{ "<leader>og", "<cmd>ObsidianFollowLink<cr>", desc = "Go to link" },
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
		{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search text" },
		{ "<leader>ov", "<cmd>ObsidianWorkspace<cr>", desc = "Switch vault" },

		{ "<leader>ol", mode = { "v" }, "<cmd>ObsidianLink<cr>", desc = "Link" },
		{ "<leader>oL", mode = { "v" }, "<cmd>ObsidianLinkNew<cr>", desc = "Link (new note)" },
	})
end

function M.config()
	require("obsidian").setup({
		workspaces = require("env").obsidian_vaults,
		completion = {
			nvim_cmp = false,
			blink = true,
		},
		note_frontmatter_func = function(note)
			local out = { id = note.id, aliases = note.aliases, tags = note.tags }
			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end
			return out
		end,

		picker = {
			name = "snacks.pick",
		},

		-- Handled by `markdown.nvim`
		ui = { enable = false },
	})
end

return M
