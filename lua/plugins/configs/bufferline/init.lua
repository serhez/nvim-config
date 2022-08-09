local icons = require("icons")

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
		-- NOTE: this plugin is designed with this icon in mind,
		-- and so changing this is NOT recommended, this is intended
		-- as an escape hatch for people who cannot bear it for whatever reason
		indicator_icon = icons.bar.vertical_left,
		buffer_close_icon = icons.cross,
		modified_icon = icons.circle,
		close_icon = icons.fat_cross,
		left_trunc_marker = icons.arrow.left_circled,
		right_trunc_marker = icons.arrow.right_circled,
		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		tab_size = 18,
		diagnostics = true,
		diagnostics_indicator = function(count, _, _, _)
			return "(" .. count .. ")"
		end,
		-- NOTE: this will be called a lot so don't do any heavy processing here
		-- custom_filter = function(buf_number)
		--     -- filter out filetypes you don't want to see
		--     if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
		--         return true
		--     end
		--     -- filter out by buffer name
		--     if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
		--         return true
		--     end
		--     -- filter out based on arbitrary rules
		--     -- e.g. filter out vim wiki buffer from tabline in your work repo
		--     if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
		--         return true
		--     end
		-- end,
		offsets = { { filetype = "NvimTree", text = "Explorer", text_align = "center" } },
		show_buffer_icons = true, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
		enforce_regular_tabs = false,
		always_show_bufferline = true,
		-- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
		--     -- add custom logic
		--     return buffer_a.modified > buffer_b.modified
		-- end
	},
})
