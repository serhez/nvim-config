local M = {
	"benlubas/molten-nvim",
	dependencies = {
		"quarto-dev/quarto-nvim",
		"GCBallesteros/jupytext.nvim",
		"3rd/image.nvim",
	},
	build = ":UpdateRemotePlugins",
	event = "VimEnter",
}

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
			r = {
				function()
					require("quarto.runner").run_cell()
				end,
				"Run cell",
			},
			R = {
				name = "Run",
				a = {
					function()
						require("quarto.runner").run_all()
					end,
					"Run all cells",
				},
				A = {
					function()
						require("quarto.runner").run_all(true)
					end,
					"Run all cells (all langs)",
				},
				d = {
					function()
						require("quarto.runner").run_below()
					end,
					"Run cell and below",
				},
				l = {
					function()
						require("quarto.runner").run_line()
					end,
					"Run line",
				},
				u = {
					function()
						require("quarto.runner").run_above()
					end,
					"Run cell and above",
				},
			},
			e = { "<cmd>MoltenEvaluateOperator<cr>", "Evaluate operator" },
			E = {
				name = "Evaluate",
				c = { "<cmd>MoltenReevaluateCell<cr>", "Re-evaluate cell" },
				v = { "<cmd>MoltenEvaluateVisual<cr>", "Evaluate visual" },
			},
			o = {
				function()
					molten_output_open = not molten_output_open
					vim.fn.MoltenUpdateOption("auto_open_output", molten_output_open)
				end,
				"Output window",
			},
		},
	})
end

function M.config()
	vim.api.nvim_create_autocmd({ "BufReadPost" }, { pattern = { "*.ipynb" }, command = "MoltenInit" })
	vim.api.nvim_create_autocmd({ "BufReadPost" }, { pattern = { "*.ipynb" }, command = "QuartoActivate" })
end

return M
