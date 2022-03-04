local M = { vi = {} }

M.vi_colors = {
    n = "FlnViCyan",
    no = "FlnViCyan",
    i = "FlnStatus",
    v = "FlnViMagenta",
    V = "FlnViMagenta",
    [""] = "FlnViMagenta",
    R = "FlnViRed",
    Rv = "FlnViRed",
    r = "FlnViBlue",
    rm = "FlnViBlue",
    s = "FlnViMagenta",
    S = "FlnViMagenta",
    [""] = "FelnMagenta",
    c = "FlnViYellow",
    ["!"] = "FlnViBlue",
    t = "FlnViBlue",
}

M.icons = {
    single_space = " ",
    double_space = "  ",
    lock = "", -- #f023
    page = "☰", -- 2630
    line_number = "", -- e0a1
    connected = "", -- f817
    windows = "", -- e70f
    unix = "", -- f17c
    mac = "", -- f179
    branch = "",
    mathematical_L = "𝑳",
    vertical_bar = "┃",
    vertical_bar_thin = "│",
    block = "█",
    circle = "●",
    errors = "",
    warnings = "",
    infos = "",
    hints = "",
}

return M
