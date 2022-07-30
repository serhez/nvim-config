 vim.g.dashboard_custom_header = {
    '   SSSSSSSSSSSSSSS   HHHHHHHHH     HHHHHHHHH  ',
    ' SS:::::::::::::::S  H:::::::H     H:::::::H  ',
    'S:::::SSSSSS::::::S  H:::::::H     H:::::::H  ',
    'S:::::S     SSSSSSS  HH::::::H     H::::::HH  ',
    'S:::::S                H:::::H     H:::::H    ',
    'S:::::S                H:::::H     H:::::H    ',
    ' S::::SSSS             H::::::HHHHH::::::H    ',
    '  SS::::::SSSSS        H:::::::::::::::::H    ',
    '    SSS::::::::SS      H:::::::::::::::::H    ',
    '       SSSSSS::::S     H::::::HHHHH::::::H    ',
    '            S:::::S    H:::::H     H:::::H    ',
    '            S:::::S    H:::::H     H:::::H    ',
    'SSSSSSS     S:::::S  HH::::::H     H::::::HH  ',
    'S::::::SSSSSS:::::S  H:::::::H     H:::::::H  ',
    'S:::::::::::::::SS   H:::::::H     H:::::::H  ',
    ' SSSSSSSSSSSSSSS     HHHHHHHHH     HHHHHHHHH  ',
}

vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
    a = {description = {'  Restore last session'}, command = 'RestoreSession'},
    b = {description = {'  Recent projects     '}, command = 'Telescope projects'},
    c = {description = {'  Recent files        '}, command = 'Telescope oldfiles'},
    d = {description = {'  Find file           '}, command = 'Telescope find_files'},
    e = {description = {'  Find word           '}, command = 'Telescope live_grep'},
    f = {description = {'  Marks               '}, command = 'Telescope marks'}
}

-- file_browser = {description = {' File Browser'}, command = 'Telescope find_files'},

-- vim.g.dashboard_custom_shortcut = {
--     a = 'f',
--     find_word = 'SPC f a',
--     last_session = 'SPC s l',
--     new_file = 'SPC c n',
--     book_marks = 'SPC f b'
-- }
-- find_history = 'SPC f h',

-- vim.g.dashboard_session_directory = '~/.cache/nvim/session'
vim.g.dashboard_custom_footer = {''}
