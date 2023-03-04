local icons = require("icons")
local mappings = require("mappings")
local hls = require("highlights")

local M = {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
}

function M.init()
	mappings.register_normal({
		b = {
			c = {
				g = { "<cmd>BufferLineGroupClose<cr>", "Group" }, -- Redundancy
				l = { "<cmd>BufferLineCloseLeft<cr>", "Left of current" },
				p = { "<cmd>BufferLinePickClose<cr>", "Pick" },
				r = { "<cmd>BufferLineCloseRight<cr>", "Right of current" },
			},
			g = {
				c = { "<cmd>BufferLineGroupClose<cr>", "Close" }, -- Redundancy
				t = { "<cmd>BufferLineGroupToggle<cr>", "Toggle" },
			},
			m = {
				h = { "<cmd>BufferLineMovePrev<cr>", "Previous" },
				l = { "<cmd>BufferLineMoveNext<cr>", "Next" },
			},
			p = { "<cmd>BufferLinePick<cr>", "Pick" },
			s = {
				c = { "<cmd>BufferLineSortByDirectory<cr>", "By directory" },
				t = { "<cmd>BufferLineSortByExtension<cr>", "By extension" },
			},
		},
	})
end

function M.config()
	-- These commands will navigate through buffers in order regardless of which mode you are using
	-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
	vim.api.nvim_set_keymap("n", "<TAB>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

	-- These commands will move the current buffer backwards or forwards in the bufferline
	vim.api.nvim_set_keymap("n", "<C-TAB>", ":BufferLineMoveNext<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-S-TAB>", ":BufferLineMovePrev<CR>", { noremap = true, silent = true })

	require("bufferline").setup({
		options = {
			numbers = "none",
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
				{ filetype = "neo-tree", text = "Explorer", text_align = "center" },
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
		},
	})

	local c = hls.colors()
	hls.register_hls({
		BufferLineBufferSelected = { default = true, bg = c.alt_bg, bold = true, italic = false },
		-- BufferLineIndicator = { default = true, fg = c.red },
		-- BufferLineIndicatorSelected = { default = true, fg = c.yellow },
		-- BufferLineIndicatorVisible = { default = true, fg = c.green },
	})
end

return M
