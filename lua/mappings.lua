-- Leader
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = " "

-- Yank
vim.api.nvim_set_keymap("n", "y", "<Plug>(YankyYank)", { silent = true })
vim.api.nvim_set_keymap("x", "y", "<Plug>(YankyYank)", { silent = true })
vim.api.nvim_set_keymap("n", "p", "<Plug>(YankyPutAfterFilter)", { silent = true })
vim.api.nvim_set_keymap("x", "p", "<Plug>(YankyPutAfterFilter)", { silent = true })
vim.api.nvim_set_keymap("n", "P", "<Plug>(YankyPutBeforeFilter)", { silent = true })
vim.api.nvim_set_keymap("x", "P", "<Plug>(YankyPutBeforeFilter)", { silent = true })
vim.api.nvim_set_keymap("n", "gp", "<Plug>(YankyGPutAfterFilter)", { silent = true })
vim.api.nvim_set_keymap("x", "gp", "<Plug>(YankyGPutAfterFilter)", { silent = true })
vim.api.nvim_set_keymap("n", "gP", "<Plug>(YankyGPutBeforeFilter)", { silent = true })
vim.api.nvim_set_keymap("x", "gP", "<Plug>(YankyGPutBeforeFilter)", { silent = true })
vim.api.nvim_set_keymap("n", "<c-n>", "<Plug>(YankyCycleForward)", { silent = true })
vim.api.nvim_set_keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)", { silent = true })

-- Join / split
vim.api.nvim_set_keymap("n", "J", "<cmd>TSJToggle<cr>", { silent = true })

-- Better window movement
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { silent = true })

-- Terminal window navigation
vim.cmd([[
    tnoremap <C-h> <C-\><C-N><C-w>h
    tnoremap <C-j> <C-\><C-N><C-w>j
    tnoremap <C-k> <C-\><C-N><C-w>k
    tnoremap <C-l> <C-\><C-N><C-w>l
    inoremap <C-h> <C-\><C-N><C-w>h
    inoremap <C-j> <C-\><C-N><C-w>j
    inoremap <C-k> <C-\><C-N><C-w>k
    inoremap <C-l> <C-\><C-N><C-w>l
    tnoremap <Esc> <C-\><C-n>
]])

-- Resize with arrows
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- Better indenting
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- Tab switch buffer
vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Incrementing and decrementing
vim.cmd("set nrformats=")
vim.api.nvim_set_keymap("n", "+", "<C-a>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "-", "<C-x>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "+", "g<C-a>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "-", "g<C-x>", { noremap = true, silent = true })

-- Respect wrapping with jk navigation
vim.cmd("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
vim.cmd("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

-- Switch to previous buffer with backspace
vim.api.nvim_set_keymap("n", "<Backspace>", "<C-^>", { noremap = true, silent = true })

-- Always center the cursor
vim.api.nvim_set_keymap("n", "{", "{zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "}", "}zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]c", "]czz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[c", "[czz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]j", "]jzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[j", "[jzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]s", "]szz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[s", "[szz", { noremap = true, silent = true })

-- Make . work over visual selections
vim.api.nvim_set_keymap("x", ".", ":norm.<CR>", { noremap = true, silent = true })

-- Avoid c storing in registers
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "C", '"_C', { noremap = true, silent = true })

-- Sensible clipboard paste in insert mode
vim.api.nvim_set_keymap("i", "<C-v>", "<C-r>*", { noremap = true, silent = true })

-- Y behaves like D and C
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true })

-- LSP
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ge", "<cmd>lua vim.diagnostic.open_float()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"gE",
	'<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<cr>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<cr>", { noremap = true, silent = true })

-- Commands
-- FIX: We have to wrap the commands with vim.cmd() because just calling vim.api.nvim_create_user_command() does not register them

-- Testing
vim.cmd([[lua vim.api.nvim_create_user_command("TestRunNearest", "lua require('neotest').run.run()", {})]])
vim.cmd(
	[[lua vim.api.nvim_create_user_command("TestRunFile", "lua require('neotest').run.run(vim.fn.expand('%'))", {})]]
)
vim.cmd([[lua vim.api.nvim_create_user_command("TestRunSuite", "lua require('neotest').run.run({suite = true})", {})]])
vim.cmd(
	[[lua vim.api.nvim_create_user_command("TestDebugNearest", "lua require('neotest').run.run({strategy = 'dap'})", {})]]
)
vim.cmd(
	[[lua vim.api.nvim_create_user_command("TestDebugFile", "lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})", {})]]
)
vim.cmd(
	[[lua vim.api.nvim_create_user_command("TestDebugSuite", "lua require('neotest').run.run({suite = true, strategy = 'dap'})", {})]]
)
vim.cmd([[lua vim.api.nvim_create_user_command("TestStopNearest", "lua require('neotest').run.stop()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("TestPanel", "lua require('neotest').summary.toggle()", {})]])

-- DAP
vim.cmd([[lua vim.api.nvim_create_user_command("DapStart", "lua require'dap'.continue()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapContinue", "lua require'dap'.continue()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapStop", "lua require'dap'.terminate()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapToggleBreakpoint", "lua require'dap'.toggle_breakpoint()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapListBreakpoints", "lua require'dap'.list_breakpoints()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapClearBreakpoints", "lua require'dap'.clear_breakpoints()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapStepOver", "lua require'dap'.step_over()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapStepInto", "lua require'dap'.step_into()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapStepOut", "lua require'dap'.step_out()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapStepBack", "lua require'dap'.step_back()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapToggleREPL", "lua require'dap'.repl.toggle()", {})]])
vim.cmd(
	[[lua vim.api.nvim_create_user_command("DapPauseThread", "lua require'dap'.repl.pause(<q-args>)", { nargs = 1 })]]
)
vim.cmd([[lua vim.api.nvim_create_user_command("DapUp", "lua require'dap'.repl.up()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapDown", "lua require'dap'.repl.down()", {})]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapGoToLine", "lua require'dap'.repl.goto_(<q-args>)", { nargs = 1 })]])
vim.cmd([[lua vim.api.nvim_create_user_command("DapGoToCursor", "lua require'dap'.repl.run_to_cursor()", {})]])
-- vim.cmd([[lua vim.api.nvim_create_user_command("DapTest", function()
-- 	local filetype = vim.bo.filetype
-- 	if filetype == "go" then
-- 		vim.api.nvim_exec("lua require('dap-go').debug_test()", false)
-- 	elseif filetype == "python" then
-- 		vim.api.nvim_exec("lua require('dap-python').test_method()", false)
-- 	else
-- 		print("The current debugging adapter does not support debugging individual tests")
-- 	end
-- end, {})]])
-- vim.cmd([[lua vim.api.nvim_create_user_command("DapClass", function()
-- 	local filetype = vim.bo.filetype
-- 	if filetype == "python" then
-- 		vim.api.nvim_exec("lua require('dap-python').test_class()", false)
-- 	else
-- 		print("The current debugging adapter does not support debugging individual classes")
-- 	end
-- end, {})]])
-- vim.cmd([[lua vim.api.nvim_create_user_command("DapVisualSelection", function()
-- 	local filetype = vim.bo.filetype
-- 	if filetype == "python" then
-- 		vim.api.nvim_exec("lua require('dap-python').debug_selection()", false)
-- 	else
-- 		print("The current debugging adapter does not support debugging by visual selection")
-- 	end
-- end, {})]])

-- Spectre
vim.cmd([[lua vim.api.nvim_create_user_command("Spectre", "lua require('spectre').open()", {})]])

-- Python venvs
vim.cmd([[lua vim.api.nvim_create_user_command("PickPythonVenv", "lua require('swenv.api').pick_venv()", {})]])

-- Nabla
vim.cmd([[lua vim.api.nvim_create_user_command("Nabla", "lua require('nabla').popup()", {})]])

local normal_mappings = {
	["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
	a = { "<cmd>BasicEasyAction<cr>", "Action with leap" },
	e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	q = { "<cmd>bwipeout<cr>", "Close buffer" }, -- Shortcut
	Q = { "<cmd>tabclose<cr>", "Close tab" }, -- Shortcut
	s = { "<cmd>Telescope grep_string search=<cr>", "Search text" }, -- Shortcut
	U = { "<cmd>PackerSync --preview<cr>", "Update" },

	b = {
		name = "Buffers",
		c = {
			name = "Close",
			a = { "<cmd>%bwipeout<cr>", "All" },
			c = { "<cmd>bwipeout<cr>", "Current" },
			g = { "<cmd>BufferLineGroupClose<cr>", "Group" }, -- Redundancy
			l = { "<cmd>BufferLineCloseLeft<cr>", "Left of current" },
			o = { '<cmd>%bdelete | e # | normal `"<cr>', "Others" },
			p = { "<cmd>BufferLinePickClose<cr>", "Pick" },
			r = { "<cmd>BufferLineCloseRight<cr>", "Right of current" },
		},
		g = {
			name = "Group",
			c = { "<cmd>BufferLineGroupClose<cr>", "Close" }, -- Redundancy
			t = { "<cmd>BufferLineGroupToggle<cr>", "Toggle" },
		},
		l = { "<cmd>Telescope buffers<cr>", "List" }, -- Redundancy
		m = {
			name = "Move",
			h = { "<cmd>BufferLineMovePrev<cr>", "Previous" },
			l = { "<cmd>BufferLineMoveNext<cr>", "Next" },
		},
		p = { "<cmd>BufferLinePick<cr>", "Pick" },
		s = {
			name = "Sort",
			c = { "<cmd>BufferLineSortByDirectory<cr>", "By directory" },
			t = { "<cmd>BufferLineSortByExtension<cr>", "By extension" },
		},
	},

	c = {
		name = "Code",
		a = { "<cmd>CodeActionMenu<cr>", "Action" },
		d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Diagnostics (line)" },
		D = {
			'<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<cr>',
			"Diagnostics (cursor)",
		},
		f = { "<cmd>lua require'lsp.formatting'.format()<cr>", "Format" },
		F = { "<cmd>lua require'lsp.formatting'.toggle_auto_format()<cr>", "Toggle auto-format" },
		r = { ":IncRename ", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols (file)" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Symbols (project)" },
		u = { "Usages" },
	},

	d = {
		name = "Debug",
		b = { "<cmd>DapToggleBreakpoint<cr>", "Toggle breakpoint" },
		B = {
			name = "Breakpoints",
			c = { "<cmd>DapClearBreakpoints<cr>", "Clear" },
			l = { "<cmd>DapListBreakpoints<cr>", "List" },
		},
		c = { "<cmd>DapContinue<cr>", "Continue / Start" },
		g = {
			name = "Go to",
			c = { "<cmd>DapGoToCursor<cr>", "Go to cursor" },
			l = { ":DapGoToLine", "Go to line" },
		},
		i = {
			name = "Item",
			c = { "<cmd>DapClass<cr>", "Class" },
			s = { "<cmd>DapVisualSelection<cr>", "Selection" },
			t = { "<cmd>DapTest<cr>", "Test" },
		},
		p = { ":DapPauseThread", "Pause thread" },
		r = { "<cmd>DapToggleRepl<cr>", "REPL" },
		s = {
			name = "Step",
			b = { "<cmd>DapStepOver<cr>", "Back" },
			d = { "<cmd>DapDown<cr>", "Down" },
			i = { "<cmd>DapStepInto<cr>", "Into" },
			O = { "<cmd>DapStepOver<cr>", "Out" },
			o = { "<cmd>DapStepOver<cr>", "Over" },
			u = { "<cmd>DapUp<cr>", "Up" },
		},
		S = { "<cmd>DapStop<cr>", "Stop" },
	},

	f = {
		name = "Find",
		b = { "<cmd>Telescope buffers<cr>", "Buffers" }, -- Redundancy
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		f = {
			"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/<cr>",
			"Files",
		},
		F = {
			"<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files,--no-heading,--with-filename,--line-number,--column,--smart-case,--glob=!.git/<cr>",
			"Files (+ignored)",
		},
		m = { "<cmd>Telescope marks<cr>", "Marks" },
		M = { "<cmd>Telescope man_pages<cr>", "Man pages" },
		p = { "<cmd>Telescope projects<cr>", "Projects" }, -- Redundancy
		R = { "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", "List" }, -- Redundancy
		r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
		s = { "<cmd>Telescope session-lens search_session<cr>", "Sessions" }, -- Redundancy
		t = { "<cmd>Telescope grep_string search=<cr>", "Text" },
		T = {
			'<cmd>lua require("telescope.builtin").live_grep({ additional_args = function() return { "--no-ignore", "--hidden", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--glob=!.git/" } end })<cr>',
			"Text (+ignored)",
		},
		v = { "<cmd>PickPythonVenv<cr>", "Python venvs" },
		y = { "<cmd>Telescope yank_history<cr>", "Yank history" },
	},

	g = {
		name = "Git",
		a = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Author" },
		b = {
			name = "Buffer",
			t = { "<cmd>DiffviewFileHistory %<cr>", "List commits" },
			d = { "<cmd>DiffviewOpen -- %<cr>", "Diffs" },
			D = { ":DiffviewOpen -- % ", "Diffs (specify commits)" },
			r = { "<cmd>Gitsigns reset_buffer<cr>", "Revert" },
		},
		d = { "<cmd>DiffviewOpen<cr>", "Diffs tool" },
		D = { ":DiffviewOpen ", "Diffs tool (specify commits)" },
		h = {
			name = "Hunk",
			j = { "<cmd>Gitsigns next_hunk<cr>", "Next" },
			k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev" },
			p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview" },
			r = { "<cmd>Gitsigns reset_hunk<cr>", "Revert" },
		},
		l = {
			name = "List",
			b = { "<cmd>Telescope git_branches<cr>", "Branches" },
			c = { "<cmd>DiffviewFileHistory %<cr>", "Commits (file)" },
			C = { "<cmd>DiffviewFileHistory<cr>", "Commits (workspace)" },
			s = { "<cmd>Telescope git_stash<cr>", "Stashes" },
		},
		m = { "<cmd>GitMessenger<cr>", "Last commit message" },
	},

	i = {
		name = "Installer",
		p = { "<cmd>Mason<cr>", "Panel" },
		u = { "<cmd>MasonToolsUpdate<cr>", "Update tools" },
	},

	l = {
		name = "LaTeX",
		p = { "<cmd>Nabla<cr>", "Preview formula" },
	},

	n = {
		name = "Notebooks",
		c = { "<cmd>MagmaReevaluateCell<cr>", "Run cell" },
		d = { "<cmd>MagmaDelete<cr>", "Delete cell" },
		i = { "<cmd>MagmaInit python3<cr>", "Init" },
		l = { "<cmd>MagmaEvaluateLine<cr>", "Run line" },
		o = { "<cmd>MagmaShowOutput<cr>", "Show output" },
		r = { "<cmd>MagmaRestart!<cr>", "Restart kernel" },
	},

	p = {
		name = "Projects",
		l = { "<cmd>Telescope projects<cr>", "List" }, -- Redundancy
		L = { "<cmd>Telescope session-lens search_session<cr>", "List (sessions)" }, -- Redundancy
	},

	r = {
		name = "Refactor",
		c = { "<cmd>lua require('refactoring').debug.cleanup({})<cr>", "Cleanup print statements" },
		l = { "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", "List" }, -- Redundancy
		p = { "<cmd>lua require('refactoring').debug.printf({below = true})<cr>", "Insert print statement" },
		b = {
			name = "Block",
			e = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract" },
			E = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>", "Extract to file" },
		},
		v = {
			name = "Variable",
			i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline" },
			p = { "<cmd>lua require('refactoring').debug.print_var({ normal = true })<cr>", "Print" },
		},
	},

	t = {
		name = "Tests",
		d = {
			name = "Debug",
			f = { "<cmd>TestDebugFile<cr>", "File" },
			n = { "<cmd>TestDebugNearest<cr>", "Nearest" },
			s = { "<cmd>TestDebugSuite<cr>", "Suite" },
		},
		r = {
			name = "Run",
			f = { "<cmd>TestRunFile<cr>", "File" },
			n = { "<cmd>TestRunNearest<cr>", "Nearest" },
			s = { "<cmd>TestRunSuite<cr>", "Suite" },
		},
		p = { "<cmd>TestPanel<cr>", "Panel" },
		s = { "<cmd>TestStopNearest<cr>", "Stop nearest" },
	},

	T = {
		name = "Tabs",
		c = { "<cmd>tabclose<cr>", "Close (current)" },
		n = { "<cmd>tabnew<cr>", "New" },
	},

	u = {
		name = "Utils",
		d = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Diagnostics (workspace)" },
		D = { "<cmd>DogeGenerate<cr>", "Generate docs" },
		m = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown preview" },
		s = { "<cmd>Spectre<cr>", "Search & replace" },
		r = { "<cmd>SnipRun<cr>", "Run code" },
		R = { "<cmd>SnipLive<cr>", "Run code live" },
		t = { "<cmd>TodoTrouble<cr>", "Todos" },
	},
}

local visual_mappings = {
	["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment" },

	R = { "<cmd>SnipRun<cr>", "Run" },

	f = {
		name = "Find",
		r = { "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", "List" }, -- Redundancy
		p = { "<cmd>lua require('refactoring').select_refactor()<cr>", "Pick" },
	},

	n = {
		name = "Notebooks",
		r = { "<cmd>MagmaEvaluateVisual<cr>", "Run" },
	},

	r = {
		name = "Refactor",
		l = { "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", "List" }, -- Redundancy
		f = {
			name = "Function",
			e = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract" },
			E = { "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", "Extract to file" },
		},
		v = {
			name = "Variable",
			e = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract" },
			i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline" },
			p = { "<cmd>lua require('refactoring').debug.print_var({})<cr>", "Print" },
		},
	},
}

local normal_opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local visual_opts = {
	mode = "v",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

require("which-key").register(normal_mappings, normal_opts)
require("which-key").register(visual_mappings, visual_opts)
