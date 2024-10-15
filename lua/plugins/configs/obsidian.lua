local M = {
	"epwalsh/obsidian.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		-- "hrsh7th/nvim-cmp",
		"iguanacucumber/magazine.nvim",
	},
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

		{ "<leader>O", group = "Obsidian" },
		{ "<leader>Ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
		{ "<leader>Of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find notes" },
		{ "<leader>Og", "<cmd>ObsidianFollowLink<cr>", desc = "Go to link" },
		{ "<leader>Ol", "<cmd>ObsidianLink<cr>", desc = "Link" },
		{ "<leader>OL", "<cmd>ObsidianLinkNew<cr>", desc = "Link (new note)" },
		{ "<leader>On", "<cmd>ObsidianNew ", desc = "New note" },
		{ "<leader>Oo", "<cmd>ObsidianOpen ", desc = "Open note" },
		{ "<leader>Os", "<cmd>ObsidianSearch<cr>", desc = "Search text" },
		{ "<leader>Ot", "<cmd>ObsidianToday<cr>", desc = "Today" },
	})
end

function M.config()
	require("obsidian").setup({
		dir = require("env").obsidian_vault,
		daily_notes = {
			folder = "Agenda",
		},
		completion = {
			nvim_cmp = true,
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

		-- Optional, by default commands like `:ObsidianSearch` will attempt to use
		-- telescope.nvim, fzf-lua, fzf.vim, or mini.pick (in that order), and use the
		-- first one they find. You can set this option to tell obsidian.nvim to always use this
		-- finder.
		finder = "telescope.nvim",

		-- Handled by `markdown.nvim`
		ui = { enable = false },
	})
end

return M
