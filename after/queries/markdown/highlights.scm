;; Conceal backticks
(fenced_code_block
  (fenced_code_block_delimiter) @conceal
  (#set! conceal "HO"))
(fenced_code_block
  (info_string (language) @conceal
  (#set! conceal "HE")))
