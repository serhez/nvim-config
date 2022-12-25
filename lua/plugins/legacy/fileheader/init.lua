vim.g.fileheader_auto_add = 0
vim.g.fileheader_auto_update = 0
vim.g.fileheader_author = "Sergio Hernandez"
vim.g.fileheader_default_email = "contact.sergiohernandez@gmail.com"
vim.g.fileheader_show_email = 1
vim.g.fileheader_date_format = "%d-%m-%Y %H:%M"
vim.g.fileheader_by_git_config = 0
vim.g.fileheader_new_line_at_end = 1
vim.cmd(
	"let g:fileheader_templates_map = {'*.*': ['Copyright (C) Sergio Hernandez - All Rights Reserved', '@Author: {{author}} <{{email}}>', '@Date: {{created_date}}']}"
)
