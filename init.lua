local sum = require("lsp.servers.sumneko_lua")

local present, impatient = pcall(require, "impatient")

if present then
	impatient.enable_profile()
end

require("settings")
require("colors")
require("plugins")
require("mappings")
require("autocommands")

if vim.g.neovide then
	require("neovide")
end
