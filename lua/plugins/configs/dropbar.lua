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
					-- menu:preview_symbol_at({ mouse.line, mouse.column - 1 })
					menu:update_hover_hl({ mouse.line, mouse.column - 1 })
				end,
			},
			win_configs = {
				border = "none",
				style = "minimal",
			},
		},
	})

	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		-- DropBarCurrentContext = { bg = c.statusline_bg },
		-- DropBarHover = { bg = c.statusline_bg },
		-- DropBarIconCurrentContext = { bg = c.statusline_bg },
		DropBarIconKindArray = { bg = c.statusline_bg },
		DropBarIconKindBoolean = { bg = c.statusline_bg },
		DropBarIconKindBreakStatement = { bg = c.statusline_bg },
		DropBarIconKindCall = { bg = c.statusline_bg },
		DropBarIconKindCaseStatement = { bg = c.statusline_bg },
		DropBarIconKindClass = { bg = c.statusline_bg },
		DropBarIconKindConstant = { bg = c.statusline_bg },
		DropBarIconKindConstructor = { bg = c.statusline_bg },
		DropBarIconKindContinueStatement = { bg = c.statusline_bg },
		DropBarIconKindDeclaration = { bg = c.statusline_bg },
		DropBarIconKindDelete = { bg = c.statusline_bg },
		DropBarIconKindDoStatement = { bg = c.statusline_bg },
		DropBarIconKindElseStatement = { bg = c.statusline_bg },
		DropBarIconKindEnum = { bg = c.statusline_bg },
		DropBarIconKindEnumMember = { bg = c.statusline_bg },
		DropBarIconKindEvent = { bg = c.statusline_bg },
		DropBarIconKindField = { bg = c.statusline_bg },
		DropBarIconKindFile = { bg = c.statusline_bg },
		DropBarIconKindFolder = { bg = c.statusline_bg },
		DropBarIconKindForStatement = { bg = c.statusline_bg },
		DropBarIconKindFunction = { bg = c.statusline_bg },
		DropBarIconKindH1Marker = { bg = c.statusline_bg },
		DropBarIconKindH2Marker = { bg = c.statusline_bg },
		DropBarIconKindH3Marker = { bg = c.statusline_bg },
		DropBarIconKindH4Marker = { bg = c.statusline_bg },
		DropBarIconKindH5Marker = { bg = c.statusline_bg },
		DropBarIconKindH6Marker = { bg = c.statusline_bg },
		DropBarIconKindIdentifier = { bg = c.statusline_bg },
		DropBarIconKindIfStatement = { bg = c.statusline_bg },
		DropBarIconKindInterface = { bg = c.statusline_bg },
		DropBarIconKindKeyword = { bg = c.statusline_bg },
		DropBarIconKindList = { bg = c.statusline_bg },
		DropBarIconKindMacro = { bg = c.statusline_bg },
		DropBarIconKindMarkdownH1 = { bg = c.statusline_bg },
		DropBarIconKindMarkdownH2 = { bg = c.statusline_bg },
		DropBarIconKindMarkdownH3 = { bg = c.statusline_bg },
		DropBarIconKindMarkdownH4 = { bg = c.statusline_bg },
		DropBarIconKindMarkdownH5 = { bg = c.statusline_bg },
		DropBarIconKindMarkdownH6 = { bg = c.statusline_bg },
		DropBarIconKindMethod = { bg = c.statusline_bg },
		DropBarIconKindModule = { bg = c.statusline_bg },
		DropBarIconKindNamespace = { bg = c.statusline_bg },
		DropBarIconKindNull = { bg = c.statusline_bg },
		DropBarIconKindNumber = { bg = c.statusline_bg },
		DropBarIconKindObject = { bg = c.statusline_bg },
		DropBarIconKindOperator = { bg = c.statusline_bg },
		DropBarIconKindPackage = { bg = c.statusline_bg },
		DropBarIconKindPair = { bg = c.statusline_bg },
		DropBarIconKindProperty = { bg = c.statusline_bg },
		DropBarIconKindReference = { bg = c.statusline_bg },
		DropBarIconKindRepeat = { bg = c.statusline_bg },
		DropBarIconKindScope = { bg = c.statusline_bg },
		DropBarIconKindSpecifier = { bg = c.statusline_bg },
		DropBarIconKindStatement = { bg = c.statusline_bg },
		DropBarIconKindString = { bg = c.statusline_bg },
		DropBarIconKindStruct = { bg = c.statusline_bg },
		DropBarIconKindSwitchStatement = { bg = c.statusline_bg },
		DropBarIconKindType = { bg = c.statusline_bg },
		DropBarIconKindTypeParameter = { bg = c.statusline_bg },
		DropBarIconKindUnit = { bg = c.statusline_bg },
		DropBarIconKindValue = { bg = c.statusline_bg },
		DropBarIconKindVariable = { bg = c.statusline_bg },
		DropBarIconKindWhileStatement = { bg = c.statusline_bg },
		DropBarIconUIIndicator = { bg = c.statusline_bg },
		DropBarIconUIPickPivot = { bg = c.statusline_bg },
		DropBarIconUISeparator = { bg = c.statusline_bg },
		DropBarIconUISeparatorMenu = { bg = c.statusline_bg },
		-- DropBarMenuCurrentContext = { bg = c.statusline_bg },
		-- DropBarMenuFloatBorder = { bg = c.statusline_bg },
		-- DropBarMenuHoverEntry = { bg = c.statusline_bg },
		-- DropBarMenuHoverIcon = { bg = c.statusline_bg },
		-- DropBarMenuHoverSymbol = { bg = c.statusline_bg },
		-- DropBarMenuNormalFloat = { bg = c.statusline_bg },
		-- DropBarPreview = { bg = c.statusline_bg },
		DropBarKindArray = { bg = c.statusline_bg },
		DropBarKindBoolean = { bg = c.statusline_bg },
		DropBarKindBreakStatement = { bg = c.statusline_bg },
		DropBarKindCall = { bg = c.statusline_bg },
		DropBarKindCaseStatement = { bg = c.statusline_bg },
		DropBarKindClass = { bg = c.statusline_bg },
		DropBarKindConstant = { bg = c.statusline_bg },
		DropBarKindConstructor = { bg = c.statusline_bg },
		DropBarKindContinueStatement = { bg = c.statusline_bg },
		DropBarKindDeclaration = { bg = c.statusline_bg },
		DropBarKindDelete = { bg = c.statusline_bg },
		DropBarKindDoStatement = { bg = c.statusline_bg },
		DropBarKindElseStatement = { bg = c.statusline_bg },
		DropBarKindEnum = { bg = c.statusline_bg },
		DropBarKindEnumMember = { bg = c.statusline_bg },
		DropBarKindEvent = { bg = c.statusline_bg },
		DropBarKindField = { bg = c.statusline_bg },
		DropBarKindFile = { bg = c.statusline_bg },
		DropBarKindFolder = { bg = c.statusline_bg },
		DropBarKindForStatement = { bg = c.statusline_bg },
		DropBarKindFunction = { bg = c.statusline_bg },
		DropBarKindH1Marker = { bg = c.statusline_bg },
		DropBarKindH2Marker = { bg = c.statusline_bg },
		DropBarKindH3Marker = { bg = c.statusline_bg },
		DropBarKindH4Marker = { bg = c.statusline_bg },
		DropBarKindH5Marker = { bg = c.statusline_bg },
		DropBarKindH6Marker = { bg = c.statusline_bg },
		DropBarKindIdentifier = { bg = c.statusline_bg },
		DropBarKindIfStatement = { bg = c.statusline_bg },
		DropBarKindInterface = { bg = c.statusline_bg },
		DropBarKindKeyword = { bg = c.statusline_bg },
		DropBarKindList = { bg = c.statusline_bg },
		DropBarKindMacro = { bg = c.statusline_bg },
		DropBarKindMarkdownH1 = { bg = c.statusline_bg },
		DropBarKindMarkdownH2 = { bg = c.statusline_bg },
		DropBarKindMarkdownH3 = { bg = c.statusline_bg },
		DropBarKindMarkdownH4 = { bg = c.statusline_bg },
		DropBarKindMarkdownH5 = { bg = c.statusline_bg },
		DropBarKindMarkdownH6 = { bg = c.statusline_bg },
		DropBarKindMethod = { bg = c.statusline_bg },
		DropBarKindModule = { bg = c.statusline_bg },
		DropBarKindNamespace = { bg = c.statusline_bg },
		DropBarKindNull = { bg = c.statusline_bg },
		DropBarKindNumber = { bg = c.statusline_bg },
		DropBarKindObject = { bg = c.statusline_bg },
		DropBarKindOperator = { bg = c.statusline_bg },
		DropBarKindPackage = { bg = c.statusline_bg },
		DropBarKindProperty = { bg = c.statusline_bg },
		DropBarKindReference = { bg = c.statusline_bg },
		DropBarKindRepeat = { bg = c.statusline_bg },
		DropBarKindScope = { bg = c.statusline_bg },
		DropBarKindSpecifier = { bg = c.statusline_bg },
		DropBarKindStatement = { bg = c.statusline_bg },
		DropBarKindString = { bg = c.statusline_bg },
		DropBarKindStruct = { bg = c.statusline_bg },
		DropBarKindSwitchStatement = { bg = c.statusline_bg },
		DropBarKindType = { bg = c.statusline_bg },
		DropBarKindTypeParameter = { bg = c.statusline_bg },
		DropBarKindUnit = { bg = c.statusline_bg },
		DropBarKindValue = { bg = c.statusline_bg },
		DropBarKindVariable = { bg = c.statusline_bg },
		DropBarKindWhileStatement = { bg = c.statusline_bg },
	})
end

return M
