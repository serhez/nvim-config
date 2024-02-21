local M = {
	"mfussenegger/nvim-lint",
	event = "BufReadPre",
}

function M.config()
	local lint = require("lint")

	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		callback = function()
			lint.try_lint()
		end,
	})

	require("lint").linters_by_ft = {
		-- Markdown
		markdown = {
			"vale", --[[ "markdownlint" ]]
		},

		-- Shell
		sh = { "shellcheck" },

		-- Python
		-- python = {
		--  "pylint",
		-- 	"pydocstyle",
		-- 	"mypy",
		-- },

		-- C/C++
		c = { "cppcheck" },
		cpp = { "cppcheck" },

		-- Golang
		go = { "golangcilint" },

		-- Javascript/Typescript
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		["javascript.jsx"] = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		["typescript.tsx"] = { "eslint_d" },
		svelte = { "eslint_d" },

		-- HTML
		html = { "eslint_d" },

		-- CSS
		css = { "eslint_d" },

		-- JSON
		json = { "jsonlint" },

		-- YAML
		yaml = { "yamllint" },

		-- SQL
		sql = { "sqlfluff" },
	}
end

return M
