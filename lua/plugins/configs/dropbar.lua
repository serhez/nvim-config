-- TODO: Do not display filepath/filename in focused window, display only full path in unfocused windows (no treesitter stuff)

local M = {
	"Bekaboo/dropbar.nvim",
	-- dependencies = {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- },
	lazy = false,
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	vim.keymap.set({ "n", "x", "o" }, ";", function()
		require("dropbar.api").pick()
	end)
end

-- https://github.com/Bekaboo/dropbar.nvim/issues/2#issuecomment-2353962505
local function bar_background_color_source()
	local function set_highlight_take_foreground(opts, source_hl, target_hl)
		if target_hl == nil then
			target_hl = source_hl
		end
		local fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(source_hl)), "fg#")
		if fg == "" then
			vim.api.nvim_set_hl(0, target_hl, opts)
		else
			vim.api.nvim_set_hl(0, target_hl, vim.tbl_extend("force", opts, { fg = fg }))
		end
	end

	local function color_symbols(symbols, opts)
		for _, symbol in ipairs(symbols) do
			local source_hl = symbol.icon_hl
			symbol.icon_hl = "DropbarSymbol" .. symbol.icon_hl
			symbol.name_hl = symbol.icon_hl
			set_highlight_take_foreground(opts, source_hl, symbol.icon_hl)
		end
		return symbols
	end

	return {
		get_symbols = function(buf, win, cursor)
			-- Use the background of the WinBar highlight group
			local opts = { bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("WinBar")), "bg#") }
			set_highlight_take_foreground(opts, "DropBarIconUISeparator")
			set_highlight_take_foreground(opts, "DropBarIconUIPickPivot")

			local sources = require("dropbar.sources")
			if vim.bo[buf].ft == "markdown" then
				return color_symbols(sources.markdown.get_symbols(buf, win, cursor), opts)
			end
			if vim.bo[buf].ft == "terminal" then
				return color_symbols(sources.terminal.get_symbols(buf, win, cursor), opts)
			end

			-- for _, source in ipairs({ sources.lsp }) do
			for _, source in ipairs({ sources.lsp, sources.treesitter }) do
				local symbols = source.get_symbols(buf, win, cursor)
				if not vim.tbl_isempty(symbols) then
					return color_symbols(symbols, opts)
				end
			end
			return {}
		end,
	}
end

function M.config()
	local hls = require("highlights")
	local c = hls.colors()
	hls.register_hls({
		DropBarKindFolder = { fg = c.statusline_fg },
		DropBarKindFile = { fg = c.statusline_fg },
		WinBar = { bg = c.red },
	})

	local icons = require("icons")
	local disabled_fts = { oil = "", undotree = "", diff = "", ["no-neck-pain"] = "" }

	require("dropbar").setup({
		sources = {
			path = {
				modified = function(sym)
					return sym:merge({
						name_hl = "DiagnosticSignWarn",
					})
				end,
				relative_to = function(_, win)
					if vim.api.nvim_get_current_win() ~= win then
						-- Workaround for Vim:E5002: Cannot find window number
						local ok, fullpath = pcall(vim.fn.getcwd, win)
						return ok and fullpath or vim.fn.getcwd()
					end

					local fullpath = vim.api.nvim_buf_get_name(0)
					local filename = vim.fn.fnamemodify(fullpath, ":t")
					return fullpath:sub(0, #fullpath - #filename)
				end,
			},
		},
		icons = {
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
			---@type boolean|fun(buf: integer, win: integer, info: table?): boolean
			enable = function(buf, win, _)
				return not vim.api.nvim_win_get_config(win).zindex
					and vim.fn.win_gettype(win) == ""
					and (vim.bo[buf].bt == "" or vim.bo[buf].bt == "terminal" or vim.bo[buf].bt == "nofile")
					and vim.api.nvim_buf_get_name(buf) ~= ""
					and vim.api.nvim_buf_get_name(buf) ~= "/Users/ser/.local/share/nvim/no-neck-pain_scratchpad_right.qmd"
					and vim.api.nvim_buf_get_name(buf) ~= "/Users/ser/.local/share/nvim/no-neck-pain_scratchpad_left.qmd"
					and not vim.wo[win].diff
					and (
						disabled_fts[vim.bo[buf].ft] == nil
						or (
							buf
								and vim.api.nvim_buf_is_valid(buf)
								and (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft))
								and true
							or false
						)
					)
			end,

			update_events = {
				-- Remove the 'WinEnter' event since I handle it manually for just
				-- showing the full dropbar in the current window.
				win = { "CursorMoved", "CursorMovedI", "WinResized" },
			},
			padding = {
				left = 1,
				right = 1,
			},
			pick = {
				pivots = "asdfhjklbcegimnopqrtuvwxyz1234567890",
			},
			truncate = true,
			-- sources = function(_, _)
			-- 	return { bar_background_color_source() }
			-- end,
			sources = function(buf, _)
				local sources = require("dropbar.sources")
				local utils = require("dropbar.utils")

				if vim.bo[buf].ft == "markdown" then
					return {
						sources.path,
						sources.markdown,
					}
				end

				if vim.bo[buf].buftype == "terminal" then
					return {
						sources.terminal,
					}
				end

				-- Prioritize treesitter for TSX and Vue files, since LSP does not show HTML tags
				if
					vim.bo[buf].ft == "typescriptreact"
					or vim.bo[buf].ft == "javascriptreact"
					or vim.bo[buf].ft == "vue"
				then
					return {
						sources.path,
						utils.source.fallback({
							sources.treesitter,
							sources.lsp,
						}),
					}
				end

				return {
					sources.path,
					utils.source.fallback({
						sources.lsp,
						sources.treesitter,
					}),
				}
			end,
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

	-- Required updates to detect active vs. inactive windows
	vim.api.nvim_create_autocmd("WinEnter", {
		callback = function()
			-- Refresh the dropbars except when entering the dropbar itself.
			if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].winbar == 1 then
				require("dropbar.utils.bar").exec("update")
			end
		end,
	})
end

return M
