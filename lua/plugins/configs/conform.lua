local M = {
	"stevearc/conform.nvim",
	event = "BufReadPre",
}

function M.config()
	require("conform").setup({
		formatters_by_ft = {
			-- Shell
			sh = { "shfmt" },

			-- Lua
			lua = { "stylua" },

			-- Python
			python = { "isort", "black" },

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
		},
	})
end

return M
