local env = require("env")
local mappings = require("mappings")

local M = {
	"epwalsh/obsidian.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
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
}

function M.init()
	vim.keymap.set("n", "gf", function()
		if require("obsidian").util.cursor_on_markdown_link() then
			return "<cmd>ObsidianFollowLink<CR>"
		else
			return "gf"
		end
	end, { noremap = false, expr = true })

	mappings.register_normal({
		o = {
			name = "Obsidian",
			b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
			f = { "<cmd>ObsidianQuickSwitch<cr>", "Find notes" },
			g = { "<cmd>ObsidianFollowLink<cr>", "Go to link" },
			l = { "<cmd>ObsidianLink<cr>", "Link" },
			L = { "<cmd>ObsidianLinkNew<cr>", "Link (new note)" },
			n = { ":ObsidianNew ", "New note" },
			o = { ":ObsidianOpen ", "Open note" },
			s = { "<cmd>ObsidianSearch<cr>", "Search text" },
			t = { "<cmd>ObsidianToday<cr>", "Today" },
		},
		f = {
			o = { "<cmd>ObsidianSearch<cr>", "Obsidian note" },
		},
	})
end

function M.config()
	require("obsidian").setup({
		dir = env.obsidian_vault,
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
	})
end

return M
