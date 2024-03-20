local M = {
	"benlubas/molten-nvim",
	dependencies = {
		"quarto-dev/quarto-nvim",
		"GCBallesteros/jupytext.nvim",
		"3rd/image.nvim",
	},
	build = ":UpdateRemotePlugins",
	ft = { "ipynb", "markdown", "quarto", "rmd" },
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

-- Global variable for suffix
local SAVE_SUFFIX = "_SAVEDDATA"

function _G.init_notebook()
	vim.notify("Initializing notebook...")
	vim.cmd("QuartoActivate")
	vim.cmd("MoltenInit")
end

-- Create an ipynb file at the same path and with the same name than the quarto file.
local function current_file_with_extension(extension, suffix)
	local current_file = vim.fn.expand("%")
	local current_file_without_extension = current_file:match("(.+)%..+") or current_file
	return current_file_without_extension .. suffix .. "." .. extension
end

-- Create an ipynb file at the same path and with the same name than the quarto file.
local function create_ipynb()
	local quarto_file = vim.fn.expand("%")
	local ipynb_file = string.gsub(quarto_file, ".qmd", ".ipynb")

	-- Check if the ipynb file already exists
	if vim.fn.filereadable(ipynb_file) == 0 then
		local cmd = string.format("jupytext --to ipynb %s", quarto_file)
		vim.fn.system(cmd)
	end
end

function M.init()
	vim.g.molten_image_provider = "image.nvim"
	vim.g.molten_output_win_max_height = 20
	vim.g.molten_auto_open_output = false
	vim.g.molten_output_crop_border = true
	vim.g.molten_output_win_border = { "", "━", "", "" }
	vim.g.molten_virt_text_output = true
	vim.g.molten_use_border_highlights = true
	vim.g.molten_virt_lines_off_by_1 = true
	vim.g.molten_wrap_output = true

	local mappings = require("mappings")
	mappings.register_normal({
		n = {
			name = "Notebook",
			e = {
				function()
					vim.cmd("MoltenSave " .. current_file_with_extension("json", SAVE_SUFFIX))
				end,
				"Export",
			},
			i = {
				function()
					vim.cmd("MoltenLoad " .. current_file_with_extension("json", SAVE_SUFFIX))
				end,
				"Import",
			},
			I = { "<cmd>MoltenImagePopup<cr>", "Open image" },
			k = { "<cmd>MoltenDeinit<cr>", "Kill kernel" },
			o = {
				"<cmd>noautocmd MoltenEnterOutput<cr><cmd>noautocmd MoltenEnterOutput<cr>",
				"Open output window",
			},
			S = { "<cmd>MoltenRestart<cr>", "Restart kernel" },
			s = { "<cmd>MoltenInterrupt<cr>", "Stop execution" },
		},
	})

	-- vim.api.nvim_create_autocmd(
	-- 	{ "BufReadPost" },
	-- 	{ pattern = { "*.ipynb", "*.qmd", "*.rmd" }, callback = _G.init_notebook }
	-- )

	-- Set the kernel variable for the statusline
	-- vim.api.nvim_create_autocmd({ "MoltenInitPost" }, {
	-- 	callback = function()
	-- 		require("plugins.configs.feline").set_kernel(require("molten.status").kernels())
	-- 	end,
	-- })
	-- vim.api.nvim_create_autocmd({ "MoltenDeinitPost" }, {
	-- 	callback = function()
	-- 		require("plugins.configs.feline").set_kernel(nil)
	-- 	end,
	-- })
end

return M
