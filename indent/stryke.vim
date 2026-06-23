" vim-stryke — indentation for stryke buffers
"
" stryke's block grammar is Perl's ({ } blocks, here-docs, continuation), so
" reuse Vim's perl indent engine rather than reinventing it.

if exists('b:did_indent')
  finish
endif

runtime! indent/perl.vim

" runtime! perl indent already set b:did_indent and b:undo_indent; nothing more
" to add. If the perl indent script is unavailable, fall back to autoindent.
if !exists('b:did_indent')
  setlocal autoindent
  let b:did_indent = 1
  let b:undo_indent = 'setlocal autoindent<'
endif
