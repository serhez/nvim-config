require('pretty-fold').setup{
    keep_indentation = false,
    fill_char = '━',
    sections = {
        left = {
            function() return string.rep('祉', vim.v.foldlevel) end, ' ━┫', 'content', '┣'
        },
        right = {
            '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━',
        }
    }
}
