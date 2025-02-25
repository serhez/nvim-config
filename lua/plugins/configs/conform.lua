local M = {
	"stevearc/conform.nvim",
	event = "VeryLazy",
}

function M.config()
	require("conform").setup({
		format = {
			timeout_ms = 2000,
			async = false,
			quiet = false,
		},

		formatters_by_ft = {
			-- Shell
			sh = { "shfmt" },

			-- Lua
			lua = { "stylua" },

			-- Python
			python = { "ruff_fix", "ruff_format" },

			-- C/C++
			c = { "clang_format" },
			cpp = { "clang_format" },

			-- Golang
			go = { "goimports" },

			-- Javascript/Typescript
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			["javascript.jsx"] = { "prettierd" },
			typescriptreact = { "prettierd" },
			["typescript.tsx"] = { "prettierd" },
			-- vue = { "prettierd" },
			svelte = { "prettierd" },

			-- HTML
			html = { "prettierd" },

			-- CSS
			css = { "prettierd" },

			-- Markdown & notebooks
			markdown = { "cbfmt" },
			-- markdown = { "mdformat" },
			-- markdown = { "prettierd" }, -- NOTE: prettierd sucks at markdown
			-- quarto = { "prettierd" }, -- FIX: use global prettierd config to supply parser ("markdown") and to use 4 spaces

			-- JSON
			json = { "prettierd" },

			-- YAML
			yaml = { "prettierd" },

			-- TOML
			toml = { "taplo" },

			-- Make/CMake
			make = { "cmake_format" },
			cmake = { "cmake_format" },

			-- SQL
			sql = { "sql_formatter" },

			-- Injected
			["*"] = { "injected" },
		},

		formatters = {
			injected = {
				options = {
					ignore_errors = false,
				},
			},
			prettierd = {
				env = {
					PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/.prettierrc"),
				},
			},
		},
	})

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	-- Auto-format on save
	local formatting = require("plugins.configs.mason-lspconfig.formatting")
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		group = formatting.augroup,
		callback = function(args)
			formatting.auto_format(args.buf)
		end,
	})
end

return M
