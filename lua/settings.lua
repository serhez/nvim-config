M = {}

function M.setup()
	local cmd = vim.cmd
	local opt = vim.opt
	local o = vim.o
	local icons = require("icons")
	local TERMINAL = vim.fn.expand("$TERMINAL")
	local CACHE_PATH = vim.fn.stdpath("cache")

	---  VIM ONLY COMMANDS  ---

	cmd("filetype plugin on") -- filetype detection
	cmd('let &titleold="' .. TERMINAL .. '"')
	cmd("set inccommand=split") -- show what you are substituting in real time
	cmd("set iskeyword+=-") -- treat dash as a separate word

	cmd("set wrap linebreak") -- wrap on words
	cmd("let &showbreak = '" .. icons.arrow.right_down_curved .. " '") -- change the wrapping symbol
	cmd("set whichwrap+=<,>,[,],h,l") -- move to next line with theses keys

	-- Automatically equalize splits when Vim is resized
	cmd("autocmd VimResized * wincmd =")

	-- PYTHON PATH --

	vim.g.python3_host_prog = "~/.envs/nvim/bin/python"

	---  SETTINGS  ---

	opt.confirm = true -- asks for confirmation instead of giving errors (e.g., on quitting without saving)
	opt.backup = false -- creates a backup file
	opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
	opt.cmdheight = 1 -- space in the neovim command line for displaying messages
	opt.completeopt = { "menuone", "noselect" }
	opt.conceallevel = 0 -- so that `` is visible in markdown files
	opt.fileencoding = "utf-8" -- the encoding written to a file
	opt.hidden = true -- required to keep multiple buffers and open multiple buffers
	opt.hlsearch = false -- highlight all matches on previous search pattern
	opt.ignorecase = true -- ignore case in search patterns
	opt.mouse = "a" -- allow the mouse to be used in neovim
	opt.pumheight = 10 -- pop up menu height
	opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
	opt.showtabline = 2 -- always show tabs
	opt.smartcase = true -- smart case
	opt.smartindent = true -- makes indenting smarter
	opt.autoindent = true -- makes indenting automatic
	opt.splitbelow = true -- force all horizontal splits to go below current window
	opt.splitright = true -- force all vertical splits to go to the right of current window
	opt.swapfile = false -- creates a swapfile
	opt.termguicolors = true -- set term gui colors (most terminals support this)
	opt.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)
	opt.title = true -- set the title of window to the value of the titlestring
	opt.titlestring = "%<%F  %l:%L" -- what the title of the window will be set to
	opt.undodir = CACHE_PATH .. "/undo" -- set an undo directory
	opt.undofile = true -- enable persisten undo
	opt.updatetime = 300 -- faster completion
	opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	opt.expandtab = true -- convert tabs to spaces
	opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
	opt.shortmess:append("c") -- don't pass messages to |ins-completion-menu|
	opt.tabstop = 4 -- insert 4 spaces for a tab
	opt.cursorline = true -- highlight the current line
	opt.number = true -- set numbered lines
	opt.relativenumber = true -- set relative numbered lines
	opt.signcolumn = "yes:2" -- always show the sign column, otherwise it would shift the text each time
	opt.foldcolumn = "auto" -- always show the sign column, otherwise it would shift the text each time
	opt.wrap = true -- display lines as one long line
	opt.laststatus = 3 -- display one statusline for all windows
	opt.guicursor = "i:ver100-blinkoff700-blinkon700"

	o.splitkeep = "screen"

	-- Improve quickfix window UI
	local fn = vim.fn

	function _G.qftf(info)
		local items
		local ret = {}
		if info.quickfix == 1 then
			items = fn.getqflist({ id = info.id, items = 0 }).items
		else
			items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
		end
		local limit = 31
		local fname_fmt1, fname_fmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
		local valid_fmt = "%s │%5d:%-3d│%s %s"
		for i = info.start_idx, info.end_idx do
			local e = items[i]
			local fname = ""
			local str
			if e.valid == 1 then
				if e.bufnr > 0 then
					fname = fn.bufname(e.bufnr)
					if fname == "" then
						fname = "[No Name]"
					else
						fname = fname:gsub("^" .. vim.env.HOME, "~")
					end
					-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
					if #fname <= limit then
						fname = fname_fmt1:format(fname)
					else
						fname = fname_fmt2:format(fname:sub(1 - limit))
					end
				end
				local lnum = e.lnum > 99999 and -1 or e.lnum
				local col = e.col > 999 and -1 or e.col
				local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
				str = valid_fmt:format(fname, lnum, col, qtype, e.text)
			else
				str = e.text
			end
			table.insert(ret, str)
		end
		return ret
	end

	o.qftf = "{info -> v:lua._G.qftf(info)}"
end

return M
