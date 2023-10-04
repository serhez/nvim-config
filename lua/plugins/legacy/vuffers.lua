local M = {
	"Hajime-Suzuki/vuffers.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "BufReadPre",
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		D = {
			name = "Docs",
			i = { "<cmd>DevdocsInstall ", "Install" },
			f = { "<cmd>DevdocsFetch<cr>", "Fetch" },
			o = { "<cmd>DevdocsOpenCurrentFloat<cr>", "Open (current)" },
			O = { "<cmd>DevdocsOpenFloat ", "Open (choose)" },
			u = { "<cmd>DevdocsUpdateAll<cr>", "Update all" },
			U = { "<cmd>DevdocsUninstall ", "Uninstall" },
		},
	})

	vim.api.nvim_set_keymap(
		"n",
		"<TAB>",
		"<cmd>lua require('vuffers').go_to_next_pinned_buffer()<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<S-TAB>",
		"<cmd>lua require('vuffers').go_to_prev_pinned_buffer()<cr>",
		{ noremap = true, silent = true }
	)
end

function M.config()
	local icons = require("icons")

	require("vuffers").setup({
		debug = {
			enabled = false,
			level = "error", -- "error" | "warn" | "info" | "debug" | "trace"
		},
		exclude = {
			-- do not show them on the vuffers list
			filenames = { "term://" },
			filetypes = { "lazygit", "NvimTree", "qf", "neo-tree" },
		},
		handlers = {
			-- when deleting a buffer via vuffers list (by default triggered by "d" key)
			on_delete_buffer = function(bufnr)
				vim.api.nvim_command(":bwipeout " .. bufnr)
			end,
		},
		keymaps = {
			use_default = true,
			-- key maps on the vuffers list
			view = {
				open = "l",
				delete = "d",
				pin = "p",
				unpin = "P",
				rename = "r",
			},
		},
		sort = {
			type = "none", -- "none" | "filename"
			direction = "asc", -- "asc" | "desc"
		},
		view = {
			modified_icon = icons.small_circle,
			pinned_icon = icons.pin,
			window = {
				auto_resize = false,
				width = 35,
				focus_on_open = false,
			},
		},
	})
end

return M
