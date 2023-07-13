local M = {
	"Bekaboo/dropbar.nvim",
	event = "BufReadPost",
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	vim.keymap.set({ "n", "x", "o" }, "m", function()
		require("dropbar.api").pick()
	end)
end

function M.config()
	local icons = require("icons")

	require("dropbar").setup({
		icons = {
			kinds = {
				use_devicons = true,
			},
			ui = {
				bar = {
					separator = " " .. icons.arrow.right_tall .. " ",
					extends = "…",
				},
				menu = {
					separator = " ",
					indicator = icons.arrow.right_short,
				},
			},
		},
		bar = {
			padding = {
				left = 1,
				right = 1,
			},
			pick = {
				pivots = "asdfhjklbcegimnopqrtuvwxyz1234567890",
			},
			truncate = true,
		},
		menu = {
			entry = {
				padding = {
					left = 1,
					right = 1,
				},
			},
			-- When on, preview the symbol under the cursor on CursorMoved
			preview = true,
			-- When on, automatically set the cursor to the closest previous/next
			-- clickable component in the direction of cursor movement on CursorMoved
			quick_navigation = true,
			keymaps = {
				["<LeftMouse>"] = function()
					local api = require("dropbar.api")
					local menu = api.get_current_dropbar_menu()
					if not menu then
						return
					end
					local mouse = vim.fn.getmousepos()
					if mouse.winid ~= menu.win then
						local parent_menu = api.get_dropbar_menu(mouse.winid)
						if parent_menu and parent_menu.sub_menu then
							parent_menu.sub_menu:close()
						end
						if vim.api.nvim_win_is_valid(mouse.winid) then
							vim.api.nvim_set_current_win(mouse.winid)
						end
						return
					end
					menu:click_at({ mouse.line, mouse.column }, nil, 1, "l")
				end,
				["<CR>"] = function()
					local menu = require("dropbar.api").get_current_dropbar_menu()
					if not menu then
						return
					end
					local cursor = vim.api.nvim_win_get_cursor(menu.win)
					local entry = menu.entries[cursor[1]]
					local component = entry:first_clickable(entry:displaywidth())
					if component then
						menu:click_on(component, nil, 1, "l")
					end
				end,
				["l"] = function()
					local menu = require("dropbar.api").get_current_dropbar_menu()
					if not menu then
						return
					end
					local cursor = vim.api.nvim_win_get_cursor(menu.win)
					local component = menu.entries[cursor[1]]:first_clickable(0)
					if component then
						menu:click_on(component, nil, 1, "l")
					end
				end,
				["h"] = function()
					local menu = require("dropbar.api").get_current_dropbar_menu()
					if not menu then
						return
					end
					menu:close()
				end,
				["q"] = function()
					local api = require("dropbar.api")
					local menu = api.get_current_dropbar_menu()
					while menu do
						menu:close()
						menu = api.get_current_dropbar_menu()
					end
				end,
				["<esc>"] = function()
					local api = require("dropbar.api")
					local menu = api.get_current_dropbar_menu()
					while menu do
						menu:close()
						menu = api.get_current_dropbar_menu()
					end
				end,
				["<MouseMove>"] = function()
					local menu = require("dropbar.api").get_current_dropbar_menu()
					if not menu then
						return
					end
					local mouse = vim.fn.getmousepos()
					if mouse.winid ~= menu.win then
						-- Find the root menu
						while menu and menu.prev_menu do
							menu = menu.prev_menu
						end
						if menu then
							menu:finish_preview(true)
						end
						return
					end
					if M.opts.menu.preview then
						menu:preview_symbol_at({ mouse.line, mouse.column - 1 })
					end
					menu:update_hover_hl({ mouse.line, mouse.column - 1 })
				end,
			},
			win_configs = {
				border = "none",
				style = "minimal",
			},
		},
	})
end

return M
