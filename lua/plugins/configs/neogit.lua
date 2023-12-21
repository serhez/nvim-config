local M = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"nvim-telescope/telescope.nvim", -- optional
		"sindrets/diffview.nvim", -- optional
		-- "ibhagwan/fzf-lua", -- optional
	},
	cmd = "Neogit",
	cond = not vim.g.started_by_firenvim,
}

function M.init()
	local mappings = require("mappings")
	mappings.register_normal({
		g = {
			p = { "<cmd>Neogit<cr>", "Panel" },
		},
	})
end

function M.config()
	local icons = require("icons")

	require("neogit").setup({
		disable_hint = true,
		disable_insert_on_commit = false,
		kind = "auto",
		-- use_default_keymaps = false,
		signs = {
			-- { CLOSED, OPENED }
			hunk = { "", "" },
			item = { icons.arrow.right_short_thick, icons.arrow.down_short_thick },
			section = { icons.arrow.right_short_thick, icons.arrow.down_short_thick },
		},
		commit_editor = {
			kind = "split",
		},
		-- mappings = {
		-- 	finder = {
		-- 		["<cr>"] = "Select",
		-- 		["<c-c>"] = "Close",
		-- 		["<esc>"] = "Close",
		-- 		["<c-n>"] = "Next",
		-- 		["<c-p>"] = "Previous",
		-- 		["<down>"] = "Next",
		-- 		["<up>"] = "Previous",
		-- 		["<tab>"] = "MultiselectToggleNext",
		-- 		["<s-tab>"] = "MultiselectTogglePrevious",
		-- 		["<c-j>"] = "NOP",
		-- 	},
		-- 	popup = {
		-- 		["?"] = "HelpPopup",
		-- 		["C"] = "CherryPickPopup",
		-- 		["D"] = "DiffPopup",
		-- 		["M"] = "RemotePopup",
		-- 		["P"] = "PushPopup",
		-- 		["X"] = "ResetPopup",
		-- 		["Z"] = "StashPopup",
		-- 		["b"] = "BranchPopup",
		-- 		["c"] = "CommitPopup",
		-- 		["f"] = "FetchPopup",
		-- 		["l"] = "LogPopup",
		-- 		["m"] = "MergePopup",
		-- 		["p"] = "PullPopup",
		-- 		["r"] = "RebasePopup",
		-- 		["v"] = "RevertPopup",
		-- 	},
		-- 	status = {
		-- 		["q"] = "Close",
		-- 		["I"] = "InitRepo",
		-- 		["1"] = "Depth1",
		-- 		["2"] = "Depth2",
		-- 		["3"] = "Depth3",
		-- 		["4"] = "Depth4",
		-- 		["<tab>"] = "Toggle",
		-- 		["x"] = "Discard",
		-- 		["a"] = "Stage",
		-- 		["A"] = "StageUnstaged",
		-- 		["<c-a>"] = "StageAll",
		-- 		["u"] = "Unstage",
		-- 		["U"] = "UnstageStaged",
		-- 		["d"] = "DiffAtFile",
		-- 		["$"] = "CommandHistory",
		-- 		["#"] = "Console",
		-- 		["<c-r>"] = "RefreshBuffer",
		-- 		["<enter>"] = "GoToFile",
		-- 		["<c-v>"] = "VSplitOpen",
		-- 		["<c-x>"] = "SplitOpen",
		-- 		["<c-t>"] = "TabOpen",
		-- 		["{"] = "GoToPreviousHunkHeader",
		-- 		["}"] = "GoToNextHunkHeader",
		-- 	},
		-- },
	})
end

return M
