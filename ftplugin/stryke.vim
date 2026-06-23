" vim-stryke — filetype-local settings for stryke buffers

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" stryke comments are Perl-style: '#' to end of line.
setlocal commentstring=#\ %s
setlocal comments=:#

" Continue the comment leader on <Enter> / o / O, recognize numbered lists.
setlocal formatoptions-=t
setlocal formatoptions+=croql

" Hash-sigil identifiers ($foo, @bar, %baz) read better when '$' etc. are not
" part of a word for motions; leave iskeyword as Perl's default (perl ftplugin
" handles this), only ensure ':' joins for stryke type annotations like Int|Str.

" Restore on filetype change.
let b:undo_ftplugin = 'setlocal commentstring< comments< formatoptions<'
