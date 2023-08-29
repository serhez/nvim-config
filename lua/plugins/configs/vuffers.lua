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
end

function M.config()
	require("vuffers").setup({
		debug = {
			enabled = true,
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
			modified_icon = "󰛿", -- when a buffer is modified, this icon will be shown
			pinned_icon = "󰐾",
			window = {
				auto_resize = false,
				width = 35,
				focus_on_open = false,
			},
		},
	})
end

return M
