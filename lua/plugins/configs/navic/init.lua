local icons = require("icons")

require("nvim-navic").setup({
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
})

-- FIX: Should not have to do this, but the attach checks don't work ATM
vim.g.navic_silence = true
