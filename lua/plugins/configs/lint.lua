local M = {
	"mfussenegger/nvim-lint",
	event = "VeryLazy",
}

function M.config()
	local lint = require("lint")

	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		callback = function()
			lint.try_lint()
		end,
	})

	require("lint").linters_by_ft = {
		markdown = {
			-- "vale",
			-- "markdownlint",
			"codespell",
		},
		quarto = {
			"codespell",
		},
		txt = {
			"codespell",
		},
		tex = {
			"codespell",
		},
		latex = {
			"codespell",
		},
		rmd = {
			"codespell",
		},

		sh = { "shellcheck" },

		python = {
			--  "pylint",
			-- 	"pydocstyle",
			-- 	"mypy",
			"snyk_iac",
			"trivy",
		},

		c = { "cppcheck", "trivy" },
		cpp = { "cppcheck", "trivy" },

		cs = { "trivy" },

		docker = { "snyk_iac", "trivy" },

		helm = { "snyk_iac", "trivy" },

		ruby = { "snyk_iac", "trivy" },

		rust = { "snyk_iac", "trivy" },

		terraform = { "snyk_iac", "trivy" },

		dart = { "trivy" },

		elixir = { "trivy" },

		java = { "trivy" },

		php = { "trivy" },

		go = { "golangcilint", "snyk_iac", "trivy" },

		javascript = { "eslint_d", "snyk_iac", "trivy" },
		typescript = { "eslint_d", "snyk_iac", "trivy" },
		javascriptreact = { "eslint_d" },
		["javascript.jsx"] = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		["typescript.tsx"] = { "eslint_d" },
		svelte = { "eslint_d" },

		swift = { "swiftlint" },

		html = { "eslint_d" },

		css = { "eslint_d" },

		json = { "jsonlint" },

		-- yaml = { "yamllint" }, -- too much noise

		sql = { "sqlfluff" },
	}
end

return M
