local M = {}

function M.register(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.add(mappings)
	end
end

function M.setup()
	-- Leader
	vim.g.mapleader = " "

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

	-- Incrementing and decrementing
	vim.cmd("set nrformats=")

	-- Respect wrapping with jk navigation
	vim.cmd("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
	vim.cmd("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

	M.register({
		-- NOTE: Now handled by the navigator.nvim plugin
		-- Better window movement
		-- { "<C-h>", "<C-w>h" },
		-- { "<C-j>", "<C-w>j" },
		-- { "<C-k>", "<C-w>k" },
		-- { "<C-l>", "<C-w>l" },

		-- Resize with arrows
		{ "<C-Up>", "<cmd>resize -2<cr>", desc = "Resize up" },
		{ "<C-Down>", "<cmd>resize +2<cr>", desc = "Resize down" },
		{ "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Resize left" },
		{ "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Resize right" },

		-- Window splits
		{ "_", "<cmd>split<cr>", desc = "Horizontal split" },
		{ "|", "<cmd>vsplit<cr>", desc = "Vertical split" },
		{ "<leader>_", "<cmd>split<cr>", desc = "Horizontal split" }, -- Shortcut
		{ "<leader>|", "<cmd>vsplit<cr>", desc = "Vertical split" }, -- Shortcut
		{ "<leader>Ush", "<cmd>split<cr>", desc = "Horizontal" },
		{ "<leader>Usv", "<cmd>vsplit<cr>", desc = "Vertical" },

		-- Better indenting
		{ "<", "<gv", mode = "v", desc = "Indent left" },
		{ ">", ">gv", mode = "v", desc = "Indent right" },

		-- Buffer switch
		-- { "<TAB>", "<cmd>bnext<cr>" },
		-- { "<S-TAB>", "<cmd>bprevious<cr>" },

		-- Tabs
		{ "<leader>Q", "<cmd>tabclose<cr>", desc = "Quit tab" },
		{ "<leader>Ut", "<cmd>tabnew<cr>", desc = "New tab" },
		{ "<Backspace>", "<cmd>tabnext<cr>", desc = "Next tab" },
		{ "<S-Backspace>", "<cmd>tabprev<cr>", desc = "Previous tab" },

		-- Messages and notifications
		{ "<leader>Um", "<cmd>messages<cr>", desc = "Messages" },

		-- Move selected line / block of text in visual mode
		{ "K", "<cmd>move '<-2<cr>gv-gv", mode = "x", desc = "Move block up" },
		{ "J", "<cmd>move '>+1<cr>gv-gv", mode = "x", desc = "Move block down" },

		-- Incrementing and decrementing
		{ "+", "<C-a>", desc = "Increment" },
		{ "-", "<C-x>", desc = "Decrement" },
		{ "+", "g<C-a>", mode = "x", desc = "Increment" },
		{ "-", "g<C-x>", mode = "x", desc = "Decrement" },

		-- Always center the cursor
		{ "{", "{zz", desc = "Next" },
		{ "}", "}zz", desc = "Next" },
		{ "n", "nzz", desc = "Next" },
		{ "N", "Nzz", desc = "Next" },
		{ "]c", "]czz", desc = "Next" },
		{ "[c", "[czz", desc = "Next" },
		{ "]j", "]jzz", desc = "Next" },
		{ "[j", "[jzz", desc = "Next" },
		{ "]s", "]szz", desc = "Next" },
		{ "[s", "[szz", desc = "Next" },

		-- Make . work over visual selections
		{ ".", "<cmd>norm.<cr>", mode = "x", desc = "Repeat" },

		-- Avoid c storing in registers
		{ "c", '"_c', desc = "Change" },
		{ "C", '"_C', desc = "Change line" },

		-- Sensible clipboard paste in insert mode
		{ "<C-v>", "<C-r>*", mode = "i", desc = "Clipboard paste" },

		-- Y behaves like D and C
		{ "Y", "y$", desc = "Yank to end of line" },

		-- LSP
		{ "K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
		{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature help" },
		-- Now handled by Trouble
		-- { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>" },
		-- { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>" },
		-- { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>" },
		-- { "gr", "<cmd>lua vim.lsp.buf.references()<cr>" },
		{ "gk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature help" },
		{ "ge", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Float diagnostics" },
		{
			"gE",
			'<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<cr>',
			desc = "Float diagnostics (cursor)",
		},
		{ "[e", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev. diagnostic" },
		{ "]e", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next diagnostic" },
	})
end

return M
