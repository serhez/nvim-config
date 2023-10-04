local M = {
	"akinsho/bufferline.nvim",
	dependencies = {
		"famiu/bufdelete.nvim",
		"axkirillov/hbac.nvim",
		"roobert/bufferline-cycle-windowless.nvim",
	},
	event = "VeryLazy",
	cond = not vim.g.started_by_firenvim,
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
		b = { "<cmd>BufferLinePick<cr>", "Buffer picker" },
		B = {
			C = {
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
			p = {
				function()
					require("hbac").toggle_pin()
					require("bufferline.groups").toggle_pin()
				end,
				"Toggle pin",
			},
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

	local present, neotree_config = pcall(require, "plugins.configs.neo-tree")
	if present then
		neotree_offset_width = neotree_config.window_width
	else
		neotree_offset_width = 0
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
					text = " " .. icons.home .. " " .. require("utils").truncate_path(
						vim.fn.getcwd(),
						neotree_offset_width - 5
					),
					text_align = "center",
				},
			},
			color_icons = true,
			show_buffer_icons = true, -- disable filetype icons for buffers
			show_buffer_close_icons = true,
			show_close_icon = false,
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
						icon = icons.filled_pin,
					}),
				},
			},
		},
	})

	-- Edgy offsets
	local Offset = require("bufferline.offset")
	if not Offset.edgy then
		local get = Offset.get
		Offset.get = function()
			if package.loaded.edgy then
				local layout = require("edgy.config").layout
				local ret = { left = "", left_size = 0, right = "", right_size = 0 }
				for _, pos in ipairs({ "left", "right" }) do
					local sb = layout[pos]
					if sb and #sb.wins > 0 then
						local cwd = " "
							.. icons.home
							.. " "
							.. require("utils").truncate_path(vim.fn.getcwd(), sb.bounds.width)
						local title = cwd .. string.rep(" ", sb.bounds.width - #cwd)
						ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
						ret[pos .. "_size"] = sb.bounds.width
					end
				end
				ret.total_size = ret.left_size + ret.right_size
				if ret.total_size > 0 then
					return ret
				end
			end
			return get()
		end
		Offset.edgy = true
	end

	local c = hls.colors()
	hls.register_hls({
		BufferLineFill = { bg = c.statusline_bg, fg = c.statusline_bg },

		BufferLineBufferSelected = { bg = c.bg, bold = true, italic = false },
		-- BufferLineTabSelected = { bg = c.cursor_line_bg, bold = true, italic = false },
		-- BufferLineIndicatorSelected = { bg = c.cursor_line_bg, bold = true, italic = false },
		-- BufferLineSeparatorSelected = { bg = c.statusline_bg, fg = c.statusline_bg, bold = true, italic = false },
		-- BufferLineDevIconLuaSelected = { default = true, bg = c.cursor_line_bg, bold = true, italic = false },
		-- BufferLineCloseButtonSelected = { bg = c.cursor_line_bg, bold = true, italic = false },
		-- BufferLineTabSeparatorSelected = { bg = c.cursor_line_bg, bold = true, italic = false },
		-- BufferLineModifiedSelected = { bg = c.cursor_line_bg, bold = true, italic = false },
		--
		-- BufferLineBackground = { bg = c.bg, bold = false, italic = false },
		-- BufferLineBuffer = { bg = c.bg, bold = false, italic = false },
		-- BufferLineTab = { bg = c.bg, bold = false, italic = false },
		-- BufferLineIndicator = { bg = c.bg, bold = false, italic = false },
		-- BufferLineSeparator = { bg = c.bg, bold = false, italic = false },
		-- BufferLineDevIconLua = { default = true, bg = c.bg, bold = false, italic = false },
		-- BufferLineCloseButton = { bg = c.bg, bold = false, italic = false },
		-- BufferLineTabSeparator = { bg = c.bg, bold = false, italic = false },
		-- BufferLineModified = { bg = c.bg, bold = false, italic = false },
	})
end

return M
