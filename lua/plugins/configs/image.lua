local M = {
	"3rd/image.nvim",
	ft = { "markdown", "quarto", "rmd", "ipynb" },
	cond = not vim.g.started_by_firenvim and not vim.g.vscode and not vim.g.neovide,
}

function M.init()
	package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
	package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
end

function M.config()
	require("image").setup({
		backend = "kitty", -- whatever backend you would like to use
		max_width = nil,
		max_height = nil,
		max_height_window_percentage = 50,
		max_width_window_percentage = 80,
		window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "quarto", "rmd" },
			},
		},
	})
end

return M
