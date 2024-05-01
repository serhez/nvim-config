local M = {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Oil",
	cond = not vim.g.started_by_firenvim and not vim.g.vscode,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		E = { "<cmd>Oil --float<cr>", "Explorer (Oil)" },
	})
end

function M.config()
	local icons = require("icons")
	local oil = require("oil")

	oil.setup({
		default_file_explorer = true,
		columns = {
			{
				"icon",
				default_file = icons.file.filled,
				directory = icons.folder.default,
				add_padding = false,
			},
		},
		win_options = {
			number = false,
			relativenumber = false,
			signcolumn = "no",
			foldcolumn = "0",
			statuscolumn = " ",
		},
		cleanup_delay_ms = 0,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = true,
		use_default_keymaps = false,
		view_options = {
			is_always_hidden = function(name)
				return name == ".."
			end,
		},
		keymaps = {
			["g?"] = "actions.show_help",
			-- ["q"] = "actions.close", -- not good because macros are useful with Oil
			["K"] = "actions.preview",
			["-"] = "actions.parent",
			["<Backspace>"] = "actions.parent",
			["="] = "actions.select",
			["+"] = "actions.select",
			["<CR>"] = "actions.select",
			["gh"] = "actions.toggle_hidden",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["go"] = {
				mode = "n",
				buffer = true,
				desc = "Choose an external program to open the entry under the cursor",
				callback = function()
					local entry = oil.get_cursor_entry()
					local dir = oil.get_current_dir()
					if not entry or not dir then
						return
					end
					local entry_path = vim.fs.joinpath(dir, entry.name)
					local response
					vim.ui.input({
						prompt = "Open with: ",
						completion = "shellcmd",
					}, function(r)
						response = r
					end)
					if not response then
						return
					end
					print("\n")
					vim.system({ response, entry_path })
				end,
			},
			["gy"] = {
				mode = "n",
				buffer = true,
				desc = "Yank the filepath of the entry under the cursor to a register",
				callback = function()
					local entry = oil.get_cursor_entry()
					local dir = oil.get_current_dir()
					if not entry or not dir then
						return
					end
					local entry_path = vim.fs.joinpath(dir, entry.name)
					vim.fn.setreg('"', entry_path)
					vim.fn.setreg(vim.v.register, entry_path)
					vim.notify(string.format("[oil] yanked '%s' to register '%s'", entry_path, vim.v.register))
				end,
			},
			["<C-o>"] = { -- Prevent jumping to file buffers by accident
				mode = "n",
				expr = true,
				buffer = true,
				desc = "Jump to older cursor position in oil buffer",
				callback = function()
					local jumplist = vim.fn.getjumplist()
					local prevloc = jumplist[1][jumplist[2]]
					return prevloc
							and vim.api.nvim_buf_is_valid(prevloc.bufnr)
							and vim.bo[prevloc.bufnr].ft == "oil"
							and "<C-o>"
						or "<Ignore>"
				end,
			},
			["<C-i>"] = {
				mode = "n",
				expr = true,
				buffer = true,
				desc = "Jump to newer cursor position in oil buffer",
				callback = function()
					local jumplist = vim.fn.getjumplist()
					local newloc = jumplist[1][jumplist[2] + 2]
					return newloc
							and vim.api.nvim_buf_is_valid(newloc.bufnr)
							and vim.bo[newloc.bufnr].ft == "oil"
							and "<C-i>"
						or "<Ignore>"
				end,
			},
		},
		float = {
			border = "solid",
			win_options = {
				winblend = 0,
			},
			padding = 5,
			max_width = 75,
		},
		preview = {
			border = "solid",
			win_options = {
				winblend = 0,
			},
		},
		progress = {
			border = "solid",
			win_options = {
				winblend = 0,
			},
		},
	})

	-- local groupid = vim.api.nvim_create_augroup("OilSyncCwd", {})
	-- vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged" }, {
	-- 	desc = "Set cwd to follow directory shown in oil buffers.",
	-- 	group = groupid,
	-- 	pattern = "oil:///*",
	-- 	callback = function(info)
	-- 		if vim.bo[info.buf].filetype == "oil" then
	-- 			local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
	-- 			local oildir = vim.fs.normalize(oil.get_current_dir())
	-- 			if cwd ~= oildir and vim.uv.fs_stat(oildir) then
	-- 				lcd(oildir)
	-- 			end
	-- 		end
	-- 	end,
	-- })
	-- vim.api.nvim_create_autocmd("DirChanged", {
	-- 	desc = "Let oil buffers follow cwd.",
	-- 	group = groupid,
	-- 	callback = function(info)
	-- 		if vim.bo[info.buf].filetype == "oil" then
	-- 			vim.defer_fn(function()
	-- 				local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
	-- 				local oildir = vim.fs.normalize(oil.get_current_dir() or "")
	-- 				if cwd ~= oildir then
	-- 					oil.open(cwd)
	-- 				end
	-- 			end, 100)
	-- 		end
	-- 	end,
	-- })
end

return M
