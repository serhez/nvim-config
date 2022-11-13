local present, impatient = pcall(require, "impatient")

if present then
	impatient.enable_profile()
end

require("settings")
require("plugins")
require("colors")
require("mappings")
require("autocommands")

if vim.g.neovide then
	require("neovide")
end
