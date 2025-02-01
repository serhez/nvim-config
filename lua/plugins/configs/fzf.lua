local M = {
	"ibhagwan/fzf-lua",
	-- build = "./install --bin",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"MeanderingProgrammer/render-markdown.nvim",
	},
	cond = not vim.g.started_by_firenvim,
	enabled = false,
}

function M.init()
	require("mappings").register({
		-- Files
		{
			"<leader>f",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
		},

		-- Text
		{
			"<leader>s",
			function()
				require("fzf-lua").grep({ resume = true })
			end,
			desc = "Search text",
		},

		-- Buffers
		{
			"<leader>bl",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "List",
		},

		-- Code
		{
			"<leader>cs",
			function()
				require("fzf-lua").treesitter()
			end,
			desc = "Symbols",
		},
		{
			"<leader>ca",
			function()
				require("fzf-lua").lsp_code_actions()
			end,
			desc = "Actions",
		},

		-- List
		{
			"<leader>lC",
			function()
				require("fzf-lua").commands()
			end,
			desc = "Commands",
		},
		-- { "<leader>lj", "<cmd>Telescope jsonfly theme=ivy<cr>", desc = "JSON keys" },
		{
			"<leader>lm",
			function()
				require("fzf-lua").marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>lM",
			function()
				require("fzf-lua").manpages()
			end,
			desc = "Man pages",
		},

		-- Git
		{
			"<leader>gb",
			function()
				require("fzf-lua").git_branches()
			end,
			desc = "Branches",
		},
		{
			"<leader>gs",
			function()
				require("fzf-lua").git_stash()
			end,
			desc = "Stashes",
		},
	})
end

function M.config()
	local utils = require("fzf-lua").utils
	local actions = require("fzf-lua.actions")
	local function hl_validate(hl)
		return not utils.is_hl_cleared(hl) and hl or nil
	end
	local default_hls = {
		bg = "PmenuSbar",
		sel = "PmenuSel",
		title = "IncSearch",
	}
	local icons = require("icons")
	local trouble_present, trouble = pcall(require, "trouble")

	require("fzf-lua").setup({
		{ "default-title" }, -- base profile
		winopts = {
			height = 0.8, -- window height
			width = 1.0, -- window width
			row = 1, -- window row position (0=top, 1=bottom)
			col = 0, -- window col position (0=left, 1=right)
			backdrop = 40,
			border = "empty",
			preview = {
				vertical = "down:45%", -- up|down:size
				horizontal = "right:55%", -- right|left:size
				layout = "flex", -- horizontal|vertical|flex
				flip_columns = 100, -- #cols to switch to horizontal on flex
				scrollbar = "float",
				scrolloff = "-2",
				title_pos = "center",
				border = "border-bold",
				winopts = {
					number = false,
				},
			},
		},
		files = {
			previewer = "builtin",
		},
		git = {
			icons = {
				["M"] = { icon = icons.git.modified, color = "yellow" },
				["D"] = { icon = icons.git.deleted, color = "red" },
				["A"] = { icon = icons.git.added, color = "green" },
				["R"] = { icon = icons.git.renamed, color = "yellow" },
				["C"] = { icon = icons.git.changed, color = "yellow" },
				["T"] = { icon = icons.git.type_changed, color = "magenta" },
				["?"] = { icon = icons.git.untracked, color = "magenta" },
			},
		},
		previewers = {
			builtin = {
				render_markdown = {
					enabled = true,
					filetypes = {
						["markdown"] = true,
						["quarto"] = true,
						["rmd"] = true,
					},
				},
			},
		},
		actions = {
			-- Below are the default actions, setting any value in these tables will override
			-- the defaults, to inherit from the defaults change [1] from `false` to `true`
			files = {
				-- Pickers inheriting these actions:
				--   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
				--   tags, btags, args, buffers, tabs, lines, blines
				-- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
				-- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
				-- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
				["enter"] = function(selected, opts)
					if trouble_present then
						opts.copen = function(_, _)
							trouble.open({ mode = "qflist" })
						end
						opts.lopen = function(_, _)
							trouble.open({ mode = "loclist" })
						end
						actions.file_edit_or_qf(selected, opts)
					end
				end,
				["ctrl-s"] = actions.file_split,
				["ctrl-v"] = actions.file_vsplit,
			},
		},
		keymap = {
			-- Below are the default binds, setting any value in these tables will override
			-- the defaults, to inherit from the defaults change [1] from `false` to `true`
			builtin = {
				["<ScrollWheelDown>"] = "preview-page-down",
				["<ScrollWheelUp>"] = "preview-page-up",
				["<S-d>"] = "preview-down",
				["<S-u>"] = "preview-up",
			},
			fzf = {
				["alt-j"] = "down",
				["alt-k"] = "up",
			},
		},
		fzf_colors = {
			["gutter"] = { "bg", default_hls.bg },
			["bg"] = { "bg", default_hls.bg },
			["bg+"] = { "bg", default_hls.sel },
			["fg+"] = { "fg", default_hls.sel },
			["fg"] = { "fg", "TelescopeNormal" },
			["hl"] = { "fg", "TelescopeMatching" },
			["hl+"] = { "fg", "TelescopeMatching" },
			["info"] = { "fg", "TelescopeMultiSelection" },
			["border"] = { "fg", "TelescopeBorder" },
			["query"] = { "fg", "TelescopePromptNormal" },
			["prompt"] = { "fg", "TelescopePromptPrefix" },
			["pointer"] = { "fg", "TelescopeSelectionCaret" },
			["marker"] = { "fg", "TelescopeSelectionCaret" },
			["header"] = { "fg", "TelescopeTitle" },
		},
		hls = {
			border = default_hls.bg,
			title = default_hls.title,
			preview_title = default_hls.title,
			-- preview_border = default_hls.bg,
			normal = hl_validate("TelescopeNormal"),
			help_normal = hl_validate("TelescopeNormal"),
			help_border = hl_validate("TelescopeBorder"),
			-- preview_normal = hl_validate("TelescopeNormal"),
			-- builtin preview only
			cursor = hl_validate("Cursor"),
			cursorline = hl_validate("TelescopeSelection"),
			cursorlinenr = hl_validate("TelescopeSelection"),
			search = hl_validate("IncSearch"),
		},
		grep = { rg_glob = true },
	})

	local hls = require("highlights")
	local c = hls.colors()
	local common_hls = hls.common_hls()

	hls.register_hls({
		FzfLuaPreviewBorder = common_hls.no_border_statusline,
		FzfLuaPreviewNormal = { bg = c.statusline_bg },
	})
end

return M
