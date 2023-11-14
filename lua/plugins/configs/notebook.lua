local M = {
	"meatballs/notebook.nvim",
	event = "BufReadPost",
}

function _G.define_cell(extmark)
	local api = require("notebook.api")

	if extmark == nil then
		local line = vim.api.nvim__buf_stats(0).current_lnum
		extmark, _ = api.current_extmark(line)
	end
	local start_line = extmark[1] + 1
	local end_line = extmark[3].end_row
	pcall(function()
		vim.fn.MagmaDefineCell(start_line, end_line)
	end)
end

function _G.define_all_cells()
	local settings = require("notebook.settings")

	local buffer = vim.api.nvim_get_current_buf()
	local extmarks = settings.extmarks[buffer]
	for id, cell in pairs(extmarks) do
		local extmark = vim.api.nvim_buf_get_extmark_by_id(0, settings.plugin_namespace, id, { details = true })
		if cell.cell_type == "code" then
			_G.define_cell(extmark)
		end
	end
end

function M.init()
	local mappings = require("mappings")

	mappings.register_normal({
		n = {
			c = {
				a = { "<cmd>NBAddCell<cr>", "Add" },
				d = { "<cmd>NBDeleteCell<cr>", "Delete" },
				i = { "<cmd>NBInsertCell<cr>", "Insert" },
			},
		},
	})
end

function M.config()
	require("notebook").setup({
		-- Whether to insert a blank line at the top of the notebook
		insert_blank_line = false,

		-- Whether to display the index number of a cell
		show_index = true,

		-- Whether to display the type of a cell
		show_cell_type = true,

		-- Style for the virtual text at the top of a cell
		virtual_text_style = { fg = "lightblue", italic = true },
	})

	-- vim.api.nvim_create_autocmd({ "BufRead" }, { pattern = { "*.ipynb" }, command = "MagmaInit" })
	-- vim.api.nvim_create_autocmd(
	-- 	"User",
	-- 	{ pattern = { "NBPostRender" }, callback = _G.define_all_cells }
	-- )

	-- Run MagmaInit for the first time (assuming we are lazy loading this plugin on BufRead of an ipynb file)
	-- vim.cmd("MagmaInit")
end

return M
