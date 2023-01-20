local icons = require("icons")
local hls = require("highlights")
local navic = require("nvim-navic")

local M = {}

navic.setup({
	icons = {
		File = icons.file.empty .. icons.single_space,
		Module = icons.braces .. icons.single_space,
		Namespace = icons.braces .. icons.single_space,
		Package = icons.box .. icons.single_space,
		Class = icons.small_parent_tree .. icons.single_space,
		Method = icons.cube .. icons.single_space,
		Property = icons.tool .. icons.single_space,
		Field = icons.prism .. icons.single_space,
		Constructor = icons.cube .. icons.single_space,
		Enum = icons.symmetrical_comms .. icons.single_space,
		Interface = icons.circle_conn .. icons.single_space,
		Function = icons.func .. icons.single_space,
		Variable = icons.bracketed_prism .. icons.single_space,
		Constant = icons.communicator .. icons.single_space,
		String = icons.boxed_abc .. icons.single_space,
		Number = icons.tic_tac_toe .. icons.single_space,
		Boolean = icons.both_ways .. icons.single_space,
		Array = icons.brackets .. icons.single_space,
		Object = icons.braces .. icons.single_space,
		Key = icons.abc .. icons.single_space,
		Null = icons.both_ways .. icons.single_space,
		EnumMember = icons.asymmetrical_comms .. icons.single_space,
		Struct = icons.big_parent_tree .. icons.single_space,
		Event = icons.lightning .. icons.single_space,
		Operator = icons.math_ops .. icons.single_space,
		TypeParameter = icons.quoted_letter .. icons.single_space,
	},
	separator = icons.single_space .. icons.arrow.right_short .. icons.single_space,
	highlight = true,
	depth_limit = 5,
	depth_limit_indicator = icons.three_dots,
})

local c = hls.colors()
hls.register_hls({
	NavicIconsFile = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsModule = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsNamespace = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsPackage = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsClass = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsMethod = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsProperty = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsField = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsConstructor = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsEnum = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsInterface = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsFunction = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsVariable = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsConstant = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsString = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsNumber = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsBoolean = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsArray = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsObject = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsKey = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsNull = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsEnumMember = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsStruct = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsEvent = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsOperator = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicIconsTypeParameter = { default = true, bg = c.statusline_bg, fg = c.cyan },
	NavicText = { bg = c.statusline_bg, fg = c.statusline_fg },
	NavicSeparator = { bg = c.statusline_bg, fg = c.statusline_fg },
})

function M.get_location()
	local location = navic.get_location()
	if not location or location == "" then
		return "%*%#NavicText#"
	else
		return "%*%#NavicSeparator#" .. icons.single_space .. location .. "%*%#NavicText#"
	end
end

vim.o.winbar = "%{%v:lua.require'plugins.configs.navic'.get_location()%}"

-- FIX: Should not have to do this, but the attach checks don't work ATM
vim.g.navic_silence = true

return M
