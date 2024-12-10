local M = {
	"nmac427/guess-indent.nvim",
	-- Required by hlchunk and any other plugins that uses it
}

function M.config()
	require("guess-indent").setup({
		auto_cmd = true, -- Set to false to disable automatic execution
		override_editorconfig = true, -- Set to true to override settings set by .editorconfig
	})
end

return M
