local dap = require("dap")
local icons = require("icons")

-- DAP breakpoint icon
vim.fn.sign_define("DapBreakpoint", {
    text = icons.circle,
    texthl = "",
    linehl = "",
    numhl = "",
})

dap.adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            return "/usr/bin/python"
        end,
    },
}

dap.adapters.cpp = {
    type = "executable",
    attach = {
        pidProperty = "pid",
        pidSelect = "ask",
    },
    command = "lldb-vscode",
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
    },
    name = "lldb",
}
