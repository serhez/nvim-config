local M = {
	"stevearc/conform.nvim",
	event = "BufReadPre",
}

function M.config()
	require("conform").setup({
		format = {
			timeout_ms = 3000,
			async = false, -- not recommended to change
			quiet = false, -- not recommended to change
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
			vue = { "prettierd" },
			svelte = { "prettierd" },

			-- HTML
			html = { "prettierd" },

			-- CSS
			css = { "prettierd" },

			-- Markdown
			markdown = { "prettierd" },

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
			injected = { options = { ignore_errors = true } },
		},
	})

	-- Use isort with ruff
	require("conform").formatters.ruff_fix = {
		prepend_args = { "--select", "I" },
	}

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
