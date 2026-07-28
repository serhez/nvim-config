local M = {
	"echasnovski/mini.bracketed",
	event = "BufReadPost",
}

function M.config()
	-- Explicit key ownership: mini.bracketed maps every target unconditionally,
	-- so anything it would steal from another plugin is disabled here instead of
	-- being settled by load order (`suffix = ""` disables a target entirely).
	require("mini.bracketed").setup({
		comment = { suffix = "" }, -- ]c/[c -> treesitter-textobjects (class)
		conflict = { suffix = "" }, -- ]x/[x -> unclash
		location = { suffix = "" }, -- ]l/[l -> trouble
		oldfile = { suffix = "" }, -- ]o/[o -> treesitter-textobjects (loop)
		quickfix = { suffix = "" }, -- ]q/[q -> trouble
		treesitter = { suffix = "" }, -- ]t/[t -> tabs (which-key)
		undo = { suffix = "" }, -- u/<C-r> -> tiny-glimmer animations (costs ]u/[u)
	})
end

return M
