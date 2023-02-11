require("env").setup() -- Env vars are often secret keys, which is why this file is excluded from the repo
require("settings").setup()
require("mappings").setup()
require("ui.statuscolumn").setup()
require("plugins").setup()
require("highlights").setup()
require("autocommands").setup()

if vim.g.neovide then
	require("neovide").setup()
end
