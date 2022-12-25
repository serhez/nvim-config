require("settings").setup()
require("mappings").setup()
require("plugins").setup()
require("colors").setup()
require("autocommands").setup()

if vim.g.neovide then
	require("neovide").setup()
end
