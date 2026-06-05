vim.loader.enable()

require("env").setup() -- Env vars are often secret keys, which is why this file is excluded from the repo
require("bigfile").setup() -- Must be early to intercept big files before plugins load
require("settings").setup()
require("lsp").setup()
require("mappings").setup()
require("plugins").setup()
require("highlights").setup()
require("autocommands").setup()
require("ui").setup()

if vim.g.neovide then
	require("neovide").setup()
end
