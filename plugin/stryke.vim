" vim-stryke — language-server / linter wiring for stryke
"
" Ported from ~/.zpwr/install/stryke.vim. Flags verified against
" `stryke --help` (v0.17.22):
"   --lint / --check   parse + compile bytecode without running
"   --lsp              Language Server (JSON-RPC on stdio); must be the only arg
"
" Opt-outs:
"   let g:vim_stryke_no_ale = 1   " skip ALE linter registration
"   let g:vim_stryke_no_lsp = 1   " skip vim-lsp server registration

if exists('g:loaded_vim_stryke')
  finish
endif
let g:loaded_vim_stryke = 1

" ---------------------------------------------------------------------------
" ALE linter
" ---------------------------------------------------------------------------
function! StrykeProjectRoot(buffer) abort
  let l:git = ale#path#FindNearestDirectory(a:buffer, '.git')
  return !empty(l:git) ? fnamemodify(l:git, ':h:h') : expand('#' . a:buffer . ':p:h')
endfunction

function! StrykeHandler(buffer, lines) abort
  let l:output = []
  for l:line in a:lines
    " stryke errors: "<message> at <file> line <n>"
    let l:match = matchlist(l:line, '\v^(.+) at .+ line (\d+)')
    if !empty(l:match)
      call add(l:output, {'lnum': l:match[2] + 0, 'text': l:match[1], 'type': 'E'})
    endif
  endfor
  return l:output
endfunction

function! s:RegisterStrykeALE() abort
  if get(g:, 'vim_stryke_no_ale', 0)
    return
  endif
  if exists('*ale#linter#Define')
    call ale#linter#Define('stryke', {
    \   'name': 'stryke',
    \   'executable': 'stryke',
    \   'command': 'stryke --lint %t 2>&1',
    \   'callback': 'StrykeHandler',
    \   'project_root': function('StrykeProjectRoot'),
    \})
    let g:ale_linters = get(g:, 'ale_linters', {})
    let g:ale_linters.stryke = ['stryke']
  endif
endfunction

augroup vim_stryke_ale
  autocmd!
  autocmd VimEnter * call s:RegisterStrykeALE()
augroup END

" ---------------------------------------------------------------------------
" vim-lsp
" ---------------------------------------------------------------------------
if !get(g:, 'vim_stryke_no_lsp', 0) && exists('*lsp#register_server')
  call lsp#register_server({
  \   'name': 'stryke',
  \   'cmd': ['stryke', '--lsp'],
  \   'allowlist': ['stryke', 'perl'],
  \})
endif

" ---------------------------------------------------------------------------
" coc.nvim — add to coc-settings.json:
"   {
"     "languageserver": {
"       "stryke": {
"         "command": "stryke",
"         "args": ["--lsp"],
"         "filetypes": ["stryke", "perl"]
"       }
"     }
"   }
" ---------------------------------------------------------------------------
