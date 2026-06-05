local M = {
	"barrettruth/canola.nvim",
	branch = "canola",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"barrettruth/canola-collection",
		"s1n7ax/nvim-window-picker",
	},
	cmd = "Canola",
	event = {
		"BufReadCmd canola://*",
		"BufReadCmd canola-ssh://*",
		"BufNewFile canola://*",
		"BufNewFile canola-ssh://*",
	},
	cond = not vim.g.started_by_firenvim,
}

local function parent_url(url)
	if vim.endswith(url, "/") then
		return url
	end
	local parent = url:gsub("[^/]+$", "")
	return parent
end

local function load_canola_collection()
	local ok, lazy = pcall(require, "lazy")
	if ok then
		lazy.load({ plugins = { "canola-collection" } })
	end
end

local function ensure_canola_ssh_adapter()
	load_canola_collection()

	local ok_canola, canola = pcall(require, "canola")
	local ok_config, config = pcall(require, "canola.config")
	if ok_canola and ok_config and (not config.adapters or not config.adapters["canola-ssh://"]) then
		pcall(canola.register_adapter, "canola-ssh://", "ssh")
	end
end

local function overleaf_sync_root()
	local root = "~/.overleaf"
	local ok, overleaf_config = pcall(require, "overleaf.config")
	if ok then
		root = overleaf_config.get().sync_dir or root
	end

	return vim.fn.fnamemodify(vim.fn.expand(root), ":p"):gsub("/$", "")
end

local function is_inside(path, root)
	if not path or path == "" or not root or root == "" then
		return false
	end

	local normalized = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
	return normalized == root or vim.startswith(normalized, root .. "/")
end

local function canola_url_path(url)
	if not vim.startswith(url, "canola://") then
		return nil
	end

	local path = url:gsub("^canola://", "")
	return vim.fn.fnamemodify(path, ":p")
end

local function is_overleaf_buffer(bufname)
	if vim.startswith(bufname, "overleaf://") or vim.startswith(bufname, "canola-overleaf://") then
		return true
	end

	local root = overleaf_sync_root()
	if is_inside(bufname, root) then
		return true
	end

	if vim.bo.filetype == "canola" then
		local ok, canola = pcall(require, "canola")
		local url = ok and canola.get_current_url(0) or nil
		if url and vim.startswith(url, "canola-overleaf://") then
			return true
		end
		if url and is_inside(canola_url_path(url), root) then
			return true
		end
	end

	return false
end

local function open_editr_explorer()
	local ok, router = pcall(require, "editr.router")
	if not ok then
		return false
	end
	return router.first({ router.editr("explorer") })
end

local function is_remote_canola_url(url)
	return vim.startswith(tostring(url or ""), "canola-ssh://") or vim.startswith(tostring(url or ""), "scp://")
end

local function editr_canola_select(opts)
	local ok, editr = pcall(require, "editr")
	if not ok or type(editr.canola_select) ~= "function" then
		return false
	end
	return editr.canola_select(opts)
end

local function select_canola(opts)
	if editr_canola_select(opts) then
		return
	end
	require("canola").select(opts)
end

local function open_canola()
	local bufname = vim.api.nvim_buf_get_name(0)

	if is_overleaf_buffer(bufname) then
		vim.cmd("Overleaf explorer")
		return
	end

	local is_canola_url = vim.startswith(bufname, "canola://") or vim.startswith(bufname, "canola-ssh://")
	local is_scp_url = vim.startswith(bufname, "scp://")

	if is_canola_url then
		ensure_canola_ssh_adapter()
	end

	if vim.bo.filetype == "canola" or is_canola_url or is_scp_url then
		local canola = require("canola")
		local url = canola.get_current_url(0)
		if vim.bo.filetype == "canola" and url then
			if not is_remote_canola_url(url) and open_editr_explorer() then
				return
			end
			canola.open(url)
			return
		end

		if not is_remote_canola_url(bufname) and open_editr_explorer() then
			return
		end

		if is_canola_url then
			canola.open(parent_url(bufname))
			return
		end

		if is_scp_url then
			ensure_canola_ssh_adapter()
			canola.open(parent_url(bufname:gsub("^scp://", "canola-ssh://")))
			return
		end
	end

	if open_editr_explorer() then
		return
	end

	require("canola").open()
end

M.keys = {
	{
		"<leader>e",
		open_canola,
		desc = "Explorer",
	},
}

local function setup_canola_globals()
	local icons = require("icons")
	local detail = false

	vim.g.canola = {
		columns = {
			"git_status",
			{
				name = "icon",
				add_padding = false,
				default_file = icons.file.filled,
				directory = icons.folder.default,
			},
		},
		confirmation = {
			border = "solid",
		},
		cursor = true,
		float = {
			border = "solid",
			max_width = 75,
			padding = 5,
		},
		hidden = {
			enabled = false,
		},
		keymaps = {
			["-"] = false,
			["<BS>"] = {
				desc = "Go to parent directory",
				buffer = true,
				mode = "n",
				callback = function()
					require("canola").open()
				end,
			},
			["<C-c>"] = false,
			["<C-h>"] = {
				desc = "Go to parent directory",
				mode = "n",
				buffer = true,
				callback = function()
					require("canola").open()
				end,
			},
			["<C-i>"] = {
				desc = "Jump to newer cursor position",
				mode = "n",
				expr = true,
				buffer = true,
				callback = function()
					local jumplist = vim.fn.getjumplist()
					local newloc = jumplist[1][jumplist[2] + 2]
					return newloc
							and vim.api.nvim_buf_is_valid(newloc.bufnr)
							and vim.bo[newloc.bufnr].ft == "canola"
							and "<C-i>"
						or "<Ignore>"
				end,
			},
			["<C-l>"] = {
				desc = "Select the entry under the cursor",
				mode = "n",
				buffer = true,
				callback = function()
					select_canola({ close = true })
				end,
			},
			["<C-o>"] = {
				desc = "Jump to older cursor position",
				mode = "n",
				expr = true,
				buffer = true,
				callback = function()
					local jumplist = vim.fn.getjumplist()
					local prevloc = jumplist[1][jumplist[2]]
					return prevloc
							and vim.api.nvim_buf_is_valid(prevloc.bufnr)
							and vim.bo[prevloc.bufnr].ft == "canola"
							and "<C-o>"
						or "<Ignore>"
				end,
			},
			["<C-p>"] = false,
			["<C-s>"] = false,
			["<C-t>"] = false,
			["<CR>"] = {
				desc = "Select the entry under the cursor",
				mode = "n",
				buffer = true,
				callback = function()
					select_canola({ close = true })
				end,
			},
			["<S-TAB>"] = {
				desc = "Go to parent directory",
				mode = "n",
				buffer = true,
				callback = function()
					require("canola").open()
				end,
			},
			["<TAB>"] = {
				desc = "Select the entry under the cursor",
				mode = "n",
				buffer = true,
				callback = function()
					select_canola({ close = true })
				end,
			},
			["<space>e"] = false,
			K = "actions.preview",
			R = "actions.refresh",
			_ = {
				desc = "Select the entry under the cursor",
				mode = "n",
				buffer = true,
				callback = function()
					select_canola({ horizontal = true, close = true })
				end,
			},
			["`"] = false,
			["g."] = false,
			["g?"] = "actions.show_help",
			gC = {
				desc = "Change the cwd to the current entry",
				mode = "n",
				buffer = true,
				callback = function()
					local canola = require("canola")
					require("canola.actions").parent.callback()
					local dir = canola.get_current_dir()
					vim.cmd.lcd(dir)
					vim.notify("Changed cwd to " .. dir, vim.log.levels.INFO, { title = "Explorer" })
				end,
			},
			gd = {
				desc = "Toggle file detail view",
				callback = function()
					local canola = require("canola")
					detail = not detail
					if detail then
						canola.set_columns({ "icon", "permissions", "size", "mtime" })
					else
						canola.set_columns({ "icon" })
					end
				end,
			},
			gh = "actions.toggle_hidden",
			go = {
				desc = "Choose an external program to open the entry under the cursor",
				mode = "n",
				buffer = true,
				callback = function()
					local canola = require("canola")
					local entry = canola.get_cursor_entry()
					local dir = canola.get_current_dir()
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
			gs = "actions.change_sort",
			gx = "actions.open_external",
			gy = {
				desc = "Yank the filepath of the entry under the cursor to a register",
				mode = "n",
				buffer = true,
				callback = function()
					local canola = require("canola")
					local entry = canola.get_cursor_entry()
					local dir = canola.get_current_dir()
					if not entry or not dir then
						return
					end
					local entry_path = vim.fs.joinpath(dir, entry.name)
					vim.fn.setreg('"', entry_path)
					vim.fn.setreg(vim.v.register, entry_path)
					vim.notify(
						string.format("Yanked '%s' to register '%s'", entry_path, vim.v.register),
						vim.log.levels.INFO,
						{ title = "Canola" }
					)
				end,
			},
			gp = {
				desc = "Paste file from clipboard path into canola directory",
				mode = "n",
				buffer = true,
				callback = function()
					local canola = require("canola")
					local dir = canola.get_current_dir()
					if not dir then
						return
					end
					local path = vim.fn.getreg("+"):gsub("\n$", "")
					if path == "" or not vim.uv.fs_stat(path) then
						vim.notify("Clipboard does not contain a valid file path", vim.log.levels.WARN)
						return
					end
					local name = vim.fn.fnamemodify(path, ":t")
					local dest = dir .. name
					vim.uv.fs_copyfile(path, dest, function(err)
						vim.schedule(function()
							if err then
								vim.notify("Copy failed: " .. err, vim.log.levels.ERROR)
							else
								local bufname = vim.api.nvim_buf_get_name(0)
								require("canola.view").set_last_cursor(bufname, name)
								require("canola.actions").refresh.callback()
							end
						end)
					end)
				end,
			},
			gw = {
				desc = "Open file in picked window",
				mode = "n",
				buffer = true,
				callback = function()
					local canola = require("canola")
					local entry = canola.get_cursor_entry()
					if not entry or entry.type ~= "file" then
						return
					end
					local win = require("window-picker").pick_window({
						filter_rules = { autoselect_one = true, include_current_win = true },
					})
					if win then
						if editr_canola_select({ close = true, win = win }) then
							return
						end
						local dir = canola.get_current_dir()
						canola.close({ exit_if_last_buf = false })
						vim.api.nvim_set_current_win(win)
						vim.cmd.edit(vim.fs.joinpath(dir, entry.name))
					end
				end,
			},
			["g~"] = false,
			q = "actions.close",
			["|"] = {
				desc = "Select the entry under the cursor",
				mode = "n",
				buffer = true,
				callback = function()
					select_canola({ vertical = true, close = true })
				end,
			},
		},
		progress = {
			border = "solid",
		},
		watch = true,
		win = {
			concealcursor = "nvic",
			conceallevel = 3,
			cursorcolumn = false,
			foldcolumn = "0",
			list = false,
			signcolumn = "number",
			spell = false,
			winbar = "%!v:lua.get_canola_winbar()",
			wrap = false,
		},
	}

	vim.g.canola_git = {
		show = { untracked = true, ignored = false },
		format = "symbol",
	}

	vim.g.canola_ssh = {
		recursive = true,
	}

	vim.g.canola_trash = {}
end

local function set_canola_remote_host_hl()
	local winbar = vim.api.nvim_get_hl(0, { name = "WinBar", link = false })
	vim.api.nvim_set_hl(0, "CanolaRemoteHost", {
		bold = true,
		fg = winbar.fg,
		bg = winbar.bg,
	})
end

function M.init()
	setup_canola_globals()
	set_canola_remote_host_hl()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("CanolaRemoteLocation", { clear = true }),
		callback = set_canola_remote_host_hl,
	})
end

function _G.get_canola_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local canola = require("canola")
	local utils = require("utils")
	local url = canola.get_current_url(bufnr) or vim.api.nvim_buf_get_name(bufnr)
	local remote_location = utils.canola_statusline_location(url, "CanolaRemoteHost")
	if remote_location then
		return " " .. remote_location
	end

	local dir = canola.get_current_dir(bufnr)
	if dir then
		return " " .. utils.statusline_escape(vim.fn.fnamemodify(dir, ":~"))
	else
		return " " .. utils.statusline_escape(vim.api.nvim_buf_get_name(bufnr))
	end
end

function M.config()
	local canola = require("canola")
	local constants = require("canola.constants")
	local icons = require("icons")
	local blank_git_symbol = vim.fn.nr2char(0x00a0)
	local view = require("canola.view")

	if not view._hide_parent_entry then
		local should_display = view.should_display
		view.should_display = function(bufnr, entry)
			if entry[constants.FIELD_ID] == 0 and entry[constants.FIELD_NAME] == ".." then
				return false, true
			end

			return should_display(bufnr, entry)
		end
		view._hide_parent_entry = true
	end

	local git_symbols = {
		["!"] = icons.git.ignored,
		["?"] = icons.git.untracked,
		A = icons.git.added,
		C = icons.git.copied,
		D = icons.git.deleted,
		M = icons.git.modified,
		R = icons.git.renamed,
		T = icons.git.type_changed,
		U = icons.git.unmerged,
		[" "] = " ",
	}

	local git_highlights = {
		["!"] = "DiagnosticUnnecessary",
		["?"] = "DiagnosticSignWarn",
		A = "DiagnosticSignOk",
		C = "DiagnosticSignHint",
		D = "DiagnosticSignError",
		M = "DiagnosticSignInfo",
		R = "DiagnosticSignInfo",
		T = "DiagnosticSignInfo",
		U = "DiagnosticSignInfo",
	}

	require("canola.columns").register("git_status", {
		all_empty_width = function(_, bufnr)
			local dir = canola.get_current_dir(bufnr)
			return dir and require("canola.git").get_root(dir) and 1 or nil
		end,
		render = function(entry, _, bufnr)
			local dir = canola.get_current_dir(bufnr)
			if not dir then
				return nil
			end

			local name = entry[constants.FIELD_NAME]
			local status = require("canola-git").get_status(dir, name)
			if not status then
				return blank_git_symbol
			end

			local code = status.worktree or status.index
			if not code then
				return blank_git_symbol
			end

			return { git_symbols[code] or code, git_highlights[code] or status.hl }
		end,
	})

	-- Hide gitignored files and show git tracked hidden files.
	local function parse_output(proc)
		local result = proc:wait()
		local ret = {}
		if result.code == 0 then
			for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
				line = line:gsub("/$", "")
				ret[line] = true
			end
		end
		return ret
	end

	local function new_git_status()
		return setmetatable({}, {
			__index = function(self, key)
				local ignore_proc = vim.system(
					{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
					{
						cwd = key,
						text = true,
					}
				)
				local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
					cwd = key,
					text = true,
				})
				local ret = {
					ignored = parse_output(ignore_proc),
					tracked = parse_output(tracked_proc),
				}

				rawset(self, key, ret)
				return ret
			end,
		})
	end
	local git_status = new_git_status()

	local refresh = require("canola.actions").refresh
	local orig_refresh = refresh.callback
	refresh.callback = function(...)
		git_status = new_git_status()
		orig_refresh(...)
	end

	canola.set_is_hidden_file(function(name, bufnr)
		local dir = canola.get_current_dir(bufnr)
		local is_dotfile = vim.startswith(name, ".") and name ~= ".."
		if not dir then
			return is_dotfile
		end
		if is_dotfile then
			return not git_status[dir].tracked[name]
		else
			return git_status[dir].ignored[name]
		end
	end)
end

return M
