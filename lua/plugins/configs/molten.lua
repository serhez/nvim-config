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

function _G.init_notebook()
	vim.notify("Initializing notebook...")
	vim.cmd("QuartoActivate")
	vim.cmd("MoltenInit")

	-- TODO: Define notebook cells using vim.fn.MoltenDefineCell(start_col, end_col, kernel_name), which are in the form of:
	-- ```
	-- cell
	-- ```
	-- or
	-- ```{language}
	-- cell
	-- ```
end

function M.init()
	local molten_output_open = false

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
			i = { "<cmd>MoltenInit<cr>", "Initialize kernel" },
			I = {
				name = "Initialize language",
				j = { "<cmd>MoltenInit julia<cr>", "Initialize Julia" },
				p = {
					function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv ~= nil then
							-- in the form of /home/benlubas/.virtualenvs/VENV_NAME
							venv = string.match(venv, "/.+/(.+)")
							vim.cmd(("MoltenInit %s"):format(venv))
						else
							vim.cmd("MoltenInit python3")
						end
					end,
					"Initialize Python",
				},
				r = { "<cmd>MoltenInit rust<cr>", "Initialize Rust" },
			},
			-- r = {
			-- 	function()
			-- 		require("quarto.runner").run_cell()
			-- 	end,
			-- 	"Run cell",
			-- },
			-- R = {
			-- 	name = "Run",
			-- 	a = {
			-- 		function()
			-- 			require("quarto.runner").run_all()
			-- 		end,
			-- 		"Run all cells",
			-- 	},
			-- 	A = {
			-- 		function()
			-- 			require("quarto.runner").run_all(true)
			-- 		end,
			-- 		"Run all cells (all langs)",
			-- 	},
			-- 	d = {
			-- 		function()
			-- 			require("quarto.runner").run_below()
			-- 		end,
			-- 		"Run cell and below",
			-- 	},
			-- 	l = {
			-- 		function()
			-- 			require("quarto.runner").run_line()
			-- 		end,
			-- 		"Run line",
			-- 	},
			-- 	u = {
			-- 		function()
			-- 			require("quarto.runner").run_above()
			-- 		end,
			-- 		"Run cell and above",
			-- 	},
			-- },
			-- r = { "<cmd>MoltenEvaluateOperator<cr>", "Run cell" },
			-- R = {
			-- 	name = "Run",
			-- 	c = { "<cmd>MoltenReevaluateCell<cr>", "Re-run cell" },
			-- 	v = { "<cmd>MoltenEvaluateVisual<cr>", "Run visual" },
			-- },
			o = {
				function()
					molten_output_open = not molten_output_open
					vim.fn.MoltenUpdateOption("auto_open_output", molten_output_open)
				end,
				"Output window",
			},
		},
	})

	vim.api.nvim_create_autocmd(
		{ "BufReadPost" },
		{ pattern = { "*.ipynb", "*.qmd", "*.rmd" }, callback = _G.init_notebook }
	)

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
