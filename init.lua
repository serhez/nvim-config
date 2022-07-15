local present, impatient = pcall(require, "impatient")

if present then
    impatient.enable_profile()
end

require("settings")
require("mappings")
require("colors")
require("plugins")
require("autocommands")
