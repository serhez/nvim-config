local M = {}

M.none = ""
M.single_space = " "
M.double_space = "  "
M.lock = ""
M.menu = "☰"
M.line_number = ""
M.connected = ""
M.windows = ""
M.unix = ""
M.mac = ""
M.mathematical_L = "𝑳"
M.vertical_bar = "┃"
M.vertical_bar_thin = "│"
M.block = "█"
M.circle = "●"
M.double_right_arrow = "»"
M.right_arrow = "→"
M.right_short_arrow = ">"

M.file = {
    page = "",
    symlink = "",
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
}

M.git = {
    branch = "",
    unstaged = "",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "",
}

return M
