local M = {}

M.none = ""
M.single_space = " "
M.double_space = "  "
M.triple_space = "   "
M.lupa = ""
M.lock = ""
M.menu = "☰"
M.line_number = ""
M.connected = ""
M.windows = ""
M.unix = ""
M.mac = ""
M.mathematical_L = "𝑳"
M.fire = ""
M.fast = ""
M.message = ""
M.circled_check = "﫠"
M.brackets = ""
M.braces = ""
M.pointy_brackets = ""
M.shapes = "ﴯ"
M.empty_square = ""
M.circle = "●"
M.small_circle = ""
M.add = ""
M.cross = ""
M.fat_cross = ""
M.check = ""
M.three_dots = ""
M.cube = ""
M.prism = ""
M.bracketed_prism = ""
M.box = ""
M.settings = ""
M.tool = ""
M.func = ""
M.add_tag = "ﰠ"
M.tic_tac_toe = ""
M.both_ways = ""
M.small_parent_tree = ""
M.big_parent_tree = ""
M.three_children_tree = ""
M.dropdown = "פּ"
M.lightning = ""
M.filled_lightning = ""
M.math_ops = ""
M.plus_minus = ""
M.letter = ""
M.quoted_letter = ""
M.text = ""
M.a_to_z = ""
M.abc = ""
M.boxed_abc = ""
M.one_two_three = ""
M.communicator = ""
M.symmetrical_comms = ""
M.asymmetrical_comms = ""
M.circle_conn = ""
M.exit = ""
M.color_palette = ""
M.key = ""
M.ruler = "塞"

M.language = {
	python = "",
}

M.bar = {
	vertical_block = "█",
	vertical_center = "┃",
	vertical_center_thin = "│",
	vertical_left = "▎",
	upper_right_corner = "┐",
	lower_left_corner = "└",
}

M.arrow = {
	right = "→",
	down_left = "",
	right_short = "",
	right_tall = "",
	down_short = "",
	double_right_short = "»",
	left_circled = "",
	right_circled = "",
	right_down_curved = "⤷",
	circular = "↺",
	right_upper_curved = "",
}

M.greek = {
	alpha = "",
	pi = "",
}

M.file = {
	empty = "",
	filled = "",
	page = "",
	symlink = "",
	files = "",
}

M.folder = {
	default = "",
	open = "",
	empty = "",
	empty_open = "",
	symlink = "",
}

M.diagnostics = {
	error = "",
	warning = "",
	info = "",
	hint = "",
	bug = "",
}

M.git = {
	github = "",
	gitlab = "",
	logo = "",
	added = M.add,
	modified = M.small_circle,
	branch = "",
	unstaged = M.empty_square,
	staged = M.check,
	unmerged = "",
	renamed = M.arrow.right,
	untracked = "",
	conflict = "",
	ignored = "",
	deleted = M.cross,
}

M.cmp = {
	Text = M.text,
	Method = M.cube,
	Function = M.func,
	Constructor = M.settings,
	Field = M.add_tag,
	Variable = M.greek.alpha,
	Class = M.shapes,
	Interface = M.three_children_tree,
	Module = M.box,
	Property = M.add_tag,
	Unit = M.ruler,
	Value = M.one_two_three,
	Enum = M.a_to_z,
	Keyword = M.key,
	Snippet = M.pointy_brackets,
	Color = M.color_palette,
	File = M.file.filled,
	Reference = M.exit,
	Folder = M.folder.default,
	EnumMember = M.a_to_z,
	Constant = M.greek.pi,
	Struct = M.dropdown,
	Event = M.filled_lightning,
	Operator = M.plus_minus,
	TypeParameter = M.letter,
	Copilot = "",
}

M.borders = {
	straight = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
}

return M
