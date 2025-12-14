local M = {
	"folke/sidekick.nvim",
	event = "VeryLazy",
	enabled = false,
}

function M.init()
	require("mappings").register({
		{
			"<C-s>",
			function()
				-- if there is a next edit, jump to it, otherwise apply it if any
				if not require("sidekick").nes_jump_or_apply() then
					return "<C-s>" -- fallback to normal tab
				end
			end,
			desc = "Go-to/apply NES",
		},
		-- {
		-- 	"<leader>aa",
		-- 	function()
		-- 		require("sidekick.cli").toggle()
		-- 	end,
		-- 	desc = "Toggle",
		-- },
		-- {
		-- 	"<leader>am",
		-- 	function()
		-- 		require("sidekick.cli").select({ filter = { installed = true } })
		-- 	end,
		-- 	desc = "Select model",
		-- },
		-- {
		-- 	"<leader>at",
		-- 	function()
		-- 		require("sidekick.cli").send({ msg = "{this}" })
		-- 	end,
		-- 	mode = { "x", "n" },
		-- 	desc = "Send this",
		-- },
		-- {
		-- 	"<leader>av",
		-- 	function()
		-- 		require("sidekick.cli").send({ msg = "{selection}" })
		-- 	end,
		-- 	mode = { "x" },
		-- 	desc = "Send visual selection",
		-- },
		-- {
		-- 	"<leader>ap",
		-- 	function()
		-- 		require("sidekick.cli").prompt()
		-- 	end,
		-- 	mode = { "n", "x" },
		-- 	desc = "Select prompt",
		-- },
		-- {
		-- 	"<c-.>",
		-- 	function()
		-- 		require("sidekick.cli").focus()
		-- 	end,
		-- 	mode = { "n", "x", "i", "t" },
		-- 	desc = "Switch assistant focus",
		-- },
		-- Example of a keybinding to open Claude directly
		-- {
		-- 	"<leader>ac",
		-- 	function()
		-- 		require("sidekick.cli").toggle({ name = "claude", focus = true })
		-- 	end,
		-- 	desc = "Sidekick Toggle Claude",
		-- },
	})
end

function M.config()
	require("sidekick").setup({
		cli = {
			mux = {
				backend = "tmux",
				enabled = true,
			},
		},
	})
end

return M
