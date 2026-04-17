; extends

; Inject markdown into hydrogen-style markdown cells
; Each "# text" comment is treated as markdown; #offset! skips the "# " prefix
; Note: since treesitter injections read raw buffer bytes, we can't strip the prefix
; per line. Bold/italic/links/inline-code work on each line. Headings may need a
; trailing space because markdown's parser expects terminating whitespace.
(
  (comment) @injection.content
  (#lua-match? @injection.content "^# ")
  (#not-lua-match? @injection.content "^# %%%%")
  (#set! injection.language "markdown")
  (#set! injection.priority 110)
  (#offset! @injection.content 0 2 0 0)
)
