local M = {
	"folke/which-key.nvim",
	lazy = false,
}

-- local function toggle_locationlist()
-- 	local win = vim.api.nvim_get_current_win()
-- 	local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
-- 	local action = qf_winid > 0 and "lclose" or "lopen"
-- 	vim.cmd(action)
-- end
--
-- local function toggle_quicklist()
-- 	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
-- 	local action = qf_winid > 0 and "cclose" or "copen"
-- 	vim.cmd("botright " .. action)
-- end

local basic_mappings = {
	---- GROUPS
	{ "<leader>a", group = "Assistant" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>c", group = "Code" },

	{ "<leader>d", group = "Debug" },
	{ "<leader>dB", group = "Breakpoints" },

	{ "<leader>E", group = "Editor" },

	{ "<leader>g", group = "Git" },
	{ "<leader>gb", group = "Buffer" },
	{ "<leader>gl", group = "List" },

	{ "<leader>i", group = "Installer" },

	{ "<leader>l", group = "List" },
	{ "<leader>lL", group = "Location" },
	{ "<leader>lQ", group = "Quickfix" },

	{ "<leader>n", group = "Notebook" },

	{ "<leader>t", group = "Tabs" },

	{ "<leader>k", group = "Toolkit" },
	{ "<leader>k", group = "Toolkit", mode = "v" },

	{ "<leader>a", group = "Assistant", mode = "v" },
	{ "<leader>n", group = "Notebooks", mode = "v" },

	---- MAPPINGS

	-- Resize with arrows
	{ "<A-Up>", "<cmd>resize -1<cr>", desc = "Resize up" },
	{ "<A-Down>", "<cmd>resize +1<cr>", desc = "Resize down" },
	{ "<A-Left>", "<cmd>vertical resize -1<cr>", desc = "Resize left" },
	{ "<A-Right>", "<cmd>vertical resize +1<cr>", desc = "Resize right" },

	-- Window splits
	{ "_", "<cmd>split<cr>", desc = "Horizontal split" },
	{ "|", "<cmd>vsplit<cr>", desc = "Vertical split" },

	-- Better indenting
	{ "<", "<gv", mode = "v", desc = "Indent left" },
	{ ">", ">gv", mode = "v", desc = "Indent right" },

	-- Tabs
	{ "Q", "<cmd>tabclose<cr>", desc = "Quit tab" },
	{ "]t", "<cmd>tabnext<cr>", desc = "Next tab" },
	{ "[t", "<cmd>tabprev<cr>", desc = "Prev tab" },
	{ "<leader>tn", "<cmd>tabnew<cr>", desc = "New" },
	{ "<leader>tc", "<cmd>tabclose<cr>", desc = "Close current" },

	-- Messages and notifications
	{ "<leader>km", "<cmd>messages<cr>", desc = "Messages" },

	-- Move selected line / block of text in visual mode
	{ "J", "<cmd>move '>+1<cr>gv-gv", mode = "x", desc = "Move block down" },
	{ "K", "<cmd>move '<-2<cr>gv-gv", mode = "x", desc = "Move block up" },

	-- Incrementing and decrementing
	{ "+", "<C-a>", desc = "Increment number" },
	{ "-", "<C-x>", desc = "Decrement number" },
	{ "+", "g<C-a>", mode = "x", desc = "Increment number" },
	{ "-", "g<C-x>", mode = "x", desc = "Decrement number" },

	-- Always center the cursor
	{ "{", "{zz", desc = "Scroll up" },
	{ "}", "}zz", desc = "Scroll down" },
	{ "n", "nzz", desc = "Next result" },
	{ "N", "Nzz", desc = "Previous result" },
	{ "]c", "]czz", desc = "Next class" },
	{ "[c", "[czz", desc = "Previous class" },
	{ "]j", "]jzz", desc = "Next jump" },
	{ "[j", "[jzz", desc = "Previous jump" },
	{ "]s", "]szz", desc = "Next misspelling" },
	{ "[s", "[szz", desc = "Previous misspelling" },
	{ "C-o", "C-ozz", desc = "Jump out" },
	{ "C-i", "C-izz", desc = "Jump in" },

	-- Avoid c storing in registers
	{ "c", '"_c', desc = "Change" },
	{ "C", '"_C', desc = "Change to end of line" },

	-- Sensible clipboard paste in insert mode
	{ "<C-v>", "<C-r>*", mode = "i", desc = "Clipboard paste" },

	-- Y behaves like D and C
	{ "Y", "y$", desc = "Yank to end of line" },

	-- LSP
	{ "K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
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

	-- Inline hints
	{
		"<leader>kh",
		function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), {
				bufnr = nil, -- all buffers
			})
		end,
		desc = "Toggle inline hints",
	},

	-- Quickfix & location lists
	{ "<leader>Q", group = "Quickfix list" },
	{ "<leader>L", group = "Location list" },
	{ "<leader>Qd", ":cdo ", desc = "Do" },
	{ "<leader>Ld", ":ldo ", desc = "Do" },
	{ "<leader>QD", ":cfdo ", desc = "Do (file)" },
	{ "<leader>LD", ":lfdo ", desc = "Do (file)" },
	{ "<leader>Qe", ":cgete ", desc = "Create from expression" },
	{ "<leader>Le", ":lgete ", desc = "Create from expression" },
	{ "<leader>Qf", ":cfilter /", desc = "Filter" },
	{ "<leader>Lf", ":lfilter /", desc = "Filter" },
	{ "<leader>Ql", ":cf ", desc = "Load file" },
	{ "<leader>Ll", ":lf ", desc = "Load file" },
	{ "<leader>Qn", "<cmd>cnew<cr>", desc = "Next" },
	{ "<leader>Ln", "<cmd>lnew<cr>", desc = "Next" },
	{ "<leader>Qp", "<cmd>col<cr>", desc = "Previous" },
	{ "<leader>Lp", "<cmd>lol<cr>", desc = "Previous" },

	-- Folding toggle
	{ "F", "za", desc = "Toggle fold" },
}

function M.config()
	local icons = require("icons")

	require("which-key").setup({
		preset = "helix",
		icons = {
			breadcrumb = icons.arrow.double_right_short, -- symbol used in the command line area that shows your active key combo
			separator = icons.bar.vertical_center_thin, -- symbol used between a key and it's label
			group = icons.folder.open .. " ", -- symbol prepended to a group
		},
		win = {
			border = "none", -- none, single, double, shadow
			title = true, -- does not matter unless boder != "none"
			title_pos = "center", -- does not matter unless boder != "none"
			padding = { 2, 6 }, -- extra window padding [top/bottom, right/left]
		},
		show_help = false, -- show help message on the command line when the popup is visible
		show_keys = true, -- show the currently pressed key and its label as a message in the command line
	})

	require("mappings").register(basic_mappings)

	local hls = require("highlights")
	local c = hls.colors()
	local common_hls = hls.common_hls()
	hls.register_hls({
		WhichKeyNormal = { fg = c.statusline_fg, bg = c.statusline_bg },
		WhichKeyBorder = common_hls.no_border_statusline,
	})
end

return M
