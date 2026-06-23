" vim-stryke — syntax highlighting for the stryke language
"
" stryke is a parallel Perl 5 interpreter written in Rust (a Perl 5 superset).
" The base grammar is Perl, so we load Vim's perl syntax first and layer the
" stryke-only extension keywords on top. This keeps every Perl construct
" highlighted correctly while adding the modern keywords stryke introduces.

if exists('b:current_syntax')
  finish
endif

" Pull in the full Perl syntax as the foundation.
runtime! syntax/perl.vim
unlet! b:current_syntax

" stryke extension keywords (verified present in real *.stk source).
" Declaration / structure
syntax keyword strykeKeyword fn typed const let module impl trait struct enum
" Control flow
syntax keyword strykeKeyword match when then loop yield try catch finally defer
" Concurrency
syntax keyword strykeKeyword async await spawn chan

" stryke optional type names (typed my $x : Int|Str, fn ($a: Int) {}).
syntax keyword strykeType Int Str Float Bool Num Any Array Hash List Map

" stryke print builtins kept distinct from Perl's print/say.
syntax keyword strykeBuiltin p say

" Map stryke groups onto standard highlight links so every colorscheme covers
" them without bespoke tuning.
highlight default link strykeKeyword Keyword
highlight default link strykeType    Type
highlight default link strykeBuiltin Function

let b:current_syntax = 'stryke'
