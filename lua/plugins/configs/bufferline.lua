local M = {
	"akinsho/bufferline.nvim",
	dependencies = {
		"famiu/bufdelete.nvim",
		"axkirillov/hbac.nvim",
		"roobert/bufferline-cycle-windowless.nvim",
	},
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim,
	enabled = false,
}

function M.init()
	-- These commands will navigate through buffers in order regardless of which mode you are using
	-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
	-- vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>BufferLineCycleNext<cr>", { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap("n", "<S-TAB>", "<cmd>BufferLineCyclePrev<cr>", { noremap = true, silent = true })

	-- These commands will move the current buffer backwards or forwards in the bufferline
	-- vim.api.nvim_set_keymap("n", "<C-TAB>", "<cmd>BufferLineMoveNext<cr>", { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap("n", "<C-S-TAB>", "<cmd>BufferLineMovePrev<cr>", { noremap = true, silent = true })

	local mappings = require("mappings")
	mappings.register_normal({
		b = {
			c = {
				name = "Close",
				g = { "<cmd>BufferLineGroupClose<cr>", "Group" }, -- cursor_line_bgundancy
				l = { "<cmd>BufferLineCloseLeft<cr>", "Left of current" },
				p = { "<cmd>BufferLinePickClose<cr>", "Pick" },
				r = { "<cmd>BufferLineCloseRight<cr>", "Right of current" },
			},
			g = {
				name = "Group",
				c = { "<cmd>BufferLineGroupClose<cr>", "Close" }, -- cursor_line_bgundancy
				t = { "<cmd>BufferLineGroupToggle<cr>", "Toggle" },
			},
			m = {
				name = "Move",
				h = { "<cmd>BufferLineMovePrev<cr>", "Previous" },
				l = { "<cmd>BufferLineMoveNext<cr>", "Next" },
			},
			P = { "<cmd>BufferLinePick<cr>", "Buffer picker" },
			s = {
				name = "Sort",
				c = { "<cmd>BufferLineSortByDirectory<cr>", "By directory" },
				t = { "<cmd>BufferLineSortByExtension<cr>", "By extension" },
			},
		},
	})
end

function M.config()
	local icons = require("icons")
	local hls = require("highlights")
	local c = hls.colors()

	local neotree_offset_width = 0

	local present, neotree_config = pcall(require, "plugins.configs.neo-tree")
	if present then
		neotree_offset_width = neotree_config.window_width
	end

	require("bufferline").setup({
		options = {
			numbers = "none",

			-- These two commands depend on the bufdelete.nvim plugin
			close_command = "Bwipeout! %d",
			right_mouse_command = "Bwipeout! %d",

			indicator = {
				style = "none",
				-- style = "underline",
				-- icon = icons.bar.vertical_left,
			},
			buffer_close_icon = icons.cross,
			modified_icon = icons.circle,
			close_icon = icons.fat_cross,
			left_trunc_marker = icons.arrow.left_circled,
			right_trunc_marker = icons.arrow.right_circled,
			max_name_length = 18,
			max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
			tab_size = 18,
			diagnostics = false,
			offsets = {
				{ filetype = "NvimTree", text = "Explorer", text_align = "center" },
				{
					filetype = "neo-tree",
					text = icons.home
						.. " "
						.. require("utils").truncate_path(vim.fn.getcwd(), neotree_offset_width - 5),
					text_align = "center",
				},
			},
			color_icons = true,
			show_buffer_icons = true, -- disable filetype icons for buffers
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- can also be a table containing 2 custom separators
			-- [focused and unfocused]. eg: { '|', '|' }
			separator_style = { "" }, -- "slant" | "thick" | "thin" | { 'any', 'any' },
			enforce_regular_tabs = false,
			always_show_bufferline = true,

			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},

			groups = {
				items = {
					require("bufferline.groups").builtin.pinned:with({
						icon = icons.pin,
					}),
				},
			},
		},

		highlights = {
			fill = {
				fg = c.statusline_fg,
				bg = c.bg,
			},
			buffer_visible = {
				fg = c.fg,
				bg = c.bg,
				bold = true,
				italic = false,
			},
			buffer_selected = {
				fg = c.fg,
				bg = c.bg,
				bold = true,
				italic = false,
			},
			indicator_visible = {
				fg = c.fg,
				bg = c.bg,
			},
			indicator_selected = {
				fg = c.fg,
				bg = c.bg,
			},
			tab = {
				fg = c.comment_fg,
				bg = c.statusline_bg,
			},
			tab_selected = {
				fg = c.fg,
				bg = c.bg,
				bold = true,
				italic = false,
			},
			tab_separator = {
				fg = c.statusline_bg,
				bg = c.statusline_bg,
			},
			tab_separator_selected = {
				fg = c.bg,
				bg = c.bg,
				sp = c.bg,
				underline = false,
			},
			tab_close = {
				fg = c.comment_fg,
				bg = c.statusline_bg,
			},
		},
	})

	-- Edgy offsets
	-- local Offset = require("bufferline.offset")
	-- if not Offset.edgy then
	-- 	local get = Offset.get
	-- 	Offset.get = function()
	-- 		if package.loaded.edgy then
	-- 			local layout = require("edgy.config").layout
	-- 			local ret = { left = "", left_size = 0, right = "", right_size = 0 }
	-- 			for _, pos in ipairs({ "left", "right" }) do
	-- 				local sb = layout[pos]
	-- 				if sb and #sb.wins > 0 then
	-- 					local cwd = " "
	-- 						.. icons.home
	-- 						.. " "
	-- 						.. require("utils").truncate_path(vim.fn.getcwd(), sb.bounds.width)
	-- 					local title = cwd .. string.rep(" ", sb.bounds.width - #cwd)
	-- 					ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
	-- 					ret[pos .. "_size"] = sb.bounds.width
	-- 				end
	-- 			end
	-- 			ret.total_size = ret.left_size + ret.right_size
	-- 			if ret.total_size > 0 then
	-- 				return ret
	-- 			end
	-- 		end
	-- 		return get()
	-- 	end
	-- 	Offset.edgy = true
	-- end
end

return M
