local hls = require("highlights")

local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"dmitmel/cmp-cmdline-history",
		"hrsh7th/cmp-cmdline",
		"zbirenbaum/copilot-cmp",
		"rcarriga/cmp-dap",
		"petertriho/cmp-git",
		"kdheepak/cmp-latex-symbols",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"jc-doyle/cmp-pandoc-references",
	},
	event = "InsertEnter",
}

function M.config()
	local cmp = require("cmp")
	local present, luasnip = pcall(require, "luasnip")

	local has_words_before = function()
		local unpack = table.unpack or unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))

		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local normal_mappings = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif present and luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}

	local normal_formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local icons = require("icons").cmp
			vim_item.kind = string.format("%s", icons[vim_item.kind])
			vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
			vim_item.menu = ({
				cmdline_history = "History",
				cmdline = "Command",
				buffer = "Buffer",
				nvim_lsp = "LSP",
				cmp_tabnine = "Tabnine",
				copilot = "Copilot",
				path = "Path",
				luasnip = "Snippet",
				latex_symbols = "LaTeX",
				pandoc_references = "Pandoc",
				otter = "Otter",
				dap = "DAP",
				git = "Git",
			})[entry.source.name]

			return vim_item
		end,
	}

	local normal_window = {
		-- https://github.com/hrsh7th/nvim-cmp/issues/1080
		completion = {
			border = "none",
		},
		documentation = {
			border = "single",
		},
	}

	local normal_preselect = cmp.PreselectMode.None

	local normal_completion = {
		autocomplete = {
			cmp.TriggerEvent.TextChanged,
			cmp.TriggerEvent.InsertEnter,
		},
		completeopt = "menuone,noinsert,noselect",
		keyword_length = 1,
	}

	cmp.setup({
		-- Disable for comments and telescope
		enabled = function()
			local context = require("cmp.config.context")
			local buftype = vim.api.nvim_buf_get_option(0, "buftype")

			-- Disable in prompts (e.g., telescope)
			if buftype == "prompt" then
				return false
			end

			-- Keep command mode completion enabled when cursor is in a comment
			if vim.api.nvim_get_mode().mode == "c" then
				return true
			else
				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end
		end,
		completion = normal_completion,
		preselect = normal_preselect,
		window = normal_window,
		snippet = (present and {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		}) or {
			expand = function(_) end,
		},
		formatting = normal_formatting,
		mapping = normal_mappings,

		-- Order matters: it will determine the prioritization of sources when showing autocomplete suggestions
		sources = {
			-- { name = "copilot", keyword_length = 0 }, -- NOTE: keyword_length = 0 does not work for now; when it does, we can remove the autocmd
			{ name = "copilot" },
			{ name = "luasnip" },
			{
				name = "latex_symbols",
				option = {
					strategy = 0, -- mixed
				},
			},
			{ name = "pandoc_references" },
			{ name = "otter" },
			{ name = "nvim_lsp" },
			-- { name = "cmp_tabnine" },
			{ name = "path" },
			{ name = "buffer" },
			{ name = "dap" },
		},

		sorting = {
			priority_weight = 2,
			comparators = {
				require("copilot_cmp.comparators").prioritize,
				require("copilot_cmp.comparators").score,

				-- Below is the default comparitor list and order for nvim-cmp
				cmp.config.compare.offset,
				-- cmp.config.compare.scopes, -- this is commented in nvim-cmp internal config
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.locality,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
	})

	cmp.setup.filetype("gitcommit", {
		completion = normal_completion,
		preselect = normal_preselect,
		window = normal_window,
		formatting = normal_formatting,
		mapping = normal_mappings,
		sources = {
			{ name = "git" },
			{ name = "path" },
			{ name = "buffer" },
		},
	})

	-- If you enabled `native_menu`, this won't work anymore
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		window = normal_window,
		sources = {
			{ name = "path" },
			{ name = "buffer" },
			{ name = "cmdline_history" },
		},
	})

	-- If you enabled `native_menu`, this won't work anymore
	for _, cmd_type in ipairs({ ":", "?", "@" }) do
		cmp.setup.cmdline(cmd_type, {
			mapping = cmp.mapping.preset.cmdline(),
			window = normal_window,
			sources = {
				{ name = "path" },
				{ name = "cmdline" },
				{ name = "cmdline_history" },
			},
		})
	end

	-- Autocmd to enable Copilot on InsertEnter (without any character being written)
	-- NOTE: We are disabling this behaviour because we are using copilot.lua's ghost text for now
	-- NOTE: We can remove this when keyword_length = 0 is possible
	-- vim.api.nvim_create_autocmd("InsertEnter", {
	-- 	pattern = "*",
	-- 	callback = function()
	-- 		vim.schedule(function()
	-- 			cmp.complete({
	-- 				config = {
	-- 					sources = {
	-- 						{ name = "copilot" },
	-- 					},
	-- 				},
	-- 			})
	-- 		end)
	-- 	end,
	-- })

	hls.register_hls({
		CmpItemMenu = { default = true, italic = true },
	})
end

return M
