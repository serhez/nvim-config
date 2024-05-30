local M = {}

function M.register_normal(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.register(mappings, {
			mode = "n",
			prefix = "<leader>",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		})
	end
end

function M.register_visual(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.register(mappings, {
			mode = "v",
			prefix = "<leader>",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		})
	end
end

function M.setup()
	-- Leader
	vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
	vim.g.mapleader = " "

	-- NOTE: Now handled by the navigator.nvim plugin
	-- Better window movement
	-- vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { silent = true })
	-- vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { silent = true })
	-- vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { silent = true })
	-- vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { silent = true })

	-- Disable native keybindings
	vim.keymap.set("n", "q", "<Nop>")

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

	-- Window splits
	vim.api.nvim_set_keymap("n", "_", "<cmd>split<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "|", "<cmd>vsplit<cr>", { noremap = true, silent = true })

	-- Better indenting
	vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

	-- Buffer switch
	-- vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })

	-- Tab switch
	vim.api.nvim_set_keymap("n", "<Backspace>", ":tabnext<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<S-Backspace>", ":tabprev<CR>", { noremap = true, silent = true })

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
	-- Now managed by cybu
	-- vim.api.nvim_set_keymap("n", "<Backspace>", "<C-^>", { noremap = true, silent = true })

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
	vim.api.nvim_set_keymap(
		"n",
		"<C-k>",
		"<cmd>lua vim.lsp.buf.signature_help()<cr>",
		{ noremap = true, silent = true }
	)

	-- Now handled by Trouble
	-- vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { noremap = true, silent = true })

	vim.api.nvim_set_keymap(
		"n",
		"gk",
		"<cmd>lua vim.lsp.buf.signature_help()<cr>",
		{ noremap = true, silent = true, desc = "Signature help" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"ge",
		"<cmd>lua vim.diagnostic.open_float()<cr>",
		{ noremap = true, silent = true, desc = "Float diagnostics" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gE",
		'<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<cr>',
		{ noremap = true, silent = true, desc = "Float diagnostics (cursor)" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"[e",
		"<cmd>lua vim.diagnostic.goto_prev()<cr>",
		{ noremap = true, silent = true, desc = "Prev. diagnostic" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"]e",
		"<cmd>lua vim.diagnostic.goto_next()<cr>",
		{ noremap = true, silent = true, desc = "Next diagnostic" }
	)

	-- Commands
	-- FIX: We have to wrap the commands with vim.cmd() because just calling vim.api.nvim_create_user_command() does not register them

	-- Testing
	vim.cmd([[lua vim.api.nvim_create_user_command("TestRunNearest", "lua require('neotest').run.run()", {})]])
	vim.cmd(
		[[lua vim.api.nvim_create_user_command("TestRunFile", "lua require('neotest').run.run(vim.fn.expand('%'))", {})]]
	)
	vim.cmd(
		[[lua vim.api.nvim_create_user_command("TestRunSuite", "lua require('neotest').run.run({suite = true})", {})]]
	)
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
	vim.cmd(
		[[lua vim.api.nvim_create_user_command("DapGoToLine", "lua require'dap'.repl.goto_(<q-args>)", { nargs = 1 })]]
	)
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
end

return M
