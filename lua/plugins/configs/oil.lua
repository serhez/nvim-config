local M = {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Oil",
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		e = { "<cmd>Oil<cr>", "Explorer" },
		E = { "<cmd>Oil --float<cr>", "Explorer (float)" },
	})
end

local function pick(split)
	local oil = require("oil")
	local entry = oil.get_cursor_entry()
	if entry.type ~= "file" then
		return oil.select()
	end

	local win = require("window-picker").pick_window({
		autoselect_one = true,
		include_current_win = true,
	})

	if win then
		local bufnr = vim.api.nvim_get_current_buf()
		local lnum = vim.api.nvim_win_get_cursor(0)[1]
		local winnr = vim.api.nvim_win_get_number(win)
		if split == "vertical" or split == "horizontal" then
			oil.close()
		end
		vim.cmd(winnr .. "windo buffer " .. bufnr)
		vim.api.nvim_win_call(win, function()
			vim.api.nvim_win_set_cursor(win, { lnum, 1 })
			if split == "vertical" then
				return oil.select({ vertical = true, close = true })
			elseif split == "horizontal" then
				return oil.select({ horizontal = true, close = true })
			else
				return oil.select({ close = true })
			end
		end)
		return
	end
end

function M.config()
	local icons = require("icons")
	local oil = require("oil")

	oil.setup({
		default_file_explorer = true,
		delete_to_trash = true,
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
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = true,
		use_default_keymaps = false,
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name)
				return name == ".."
			end,
		},
		keymaps = {
			["g?"] = "actions.show_help",
			["q"] = "actions.close",
			["<space>e"] = "actions.close",
			["K"] = "actions.preview",
			["<M-h>"] = {
				mode = "n",
				buffer = true,
				desc = "Go to parent directory",
				callback = function()
					oil.open()
				end,
			},
			["<M-l>"] = {
				mode = "n",
				buffer = true,
				desc = "Select the entry under the cursor",
				callback = pick,
			},
			["<CR>"] = {
				mode = "n",
				buffer = true,
				desc = "Select the entry under the cursor",
				callback = pick,
			},
			["|"] = {
				mode = "n",
				buffer = true,
				desc = "Select the entry under the cursor",
				callback = function()
					pick("vertical")
				end,
			},
			["_"] = {
				mode = "n",
				buffer = true,
				desc = "Select the entry under the cursor",
				callback = function()
					pick("horizontal")
				end,
			},
			["t"] = {
				mode = "n",
				buffer = true,
				desc = "Tag the file under the cursor",
				callback = function()
					local present, grapple = pcall(require, "grapple")
					if present then
						local entry = oil.get_cursor_entry()
						if entry.type ~= "file" then
							vim.notify("Only files can be tagged", vim.log.levels.ERROR)
							return
						end
						grapple.toggle({ path = oil.get_current_dir() .. entry.name })
						vim.notify("Tagged " .. entry.name, vim.log.levels.INFO)
					else
						vim.notify_once("Grapple is not installed", vim.log.levels.ERROR)
					end
				end,
			},
			["R"] = "actions.refresh",
			["gh"] = "actions.toggle_hidden",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["gt"] = "actions.toggle_trash",
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
		ssh = {
			border = "solid",
			win_options = {
				winblend = 0,
			},
		},
	})
end

return M
