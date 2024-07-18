;; extends

;; Conceal bullet points
;; BUG: this does not work well because of issues with spaces in the list marker nodes upstream (nvim)
; ([(list_marker_plus) (list_marker_star)]
;   @punctuation.special
;   (#offset! @punctuation.special 0 0 0 -1)
;   (#set! conceal "•"))
;
; ([(list_marker_plus) (list_marker_star)]
;   @punctuation.special
;   (#any-of? @punctuation.special "+" "*")
;   (#set! conceal "•"))
;
; ((list_marker_minus)
;   @punctuation.special
;   (#offset! @punctuation.special 0 0 0 -1)
;   (#set! conceal "•"))
;
; ((list_marker_minus)
;   @punctuation.special
;   (#eq? @punctuation.special "-")
;   (#set! conceal "•"))
;
;; Conceal check-lists
 ; (list
 ;   (list_item
 ;   (list_marker_minus) @conceal (#set! conceal "")
 ;   (task_list_marker_unchecked)
 ; )) 
 ;
 ; ([
 ;   (task_list_marker_checked)
 ; ] @conceal (#set! conceal ""))
 ;
 ; ([
 ;   (task_list_marker_unchecked)
 ; ] @conceal (#set! conceal "󰄱"))

;; Conceal backticks
;; FIX: I don't want to conceal the language, but it's in the original
;;      nvim `highlights.scm` and doesn't seem to be possible to disable
; (fenced_code_block
;   (fenced_code_block_delimiter) @conceal
;   (#set! conceal ""))
;
; (fenced_code_block
;   (info_string (language) @conceal
;   (#set! conceal "")))
