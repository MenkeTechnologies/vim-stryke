" vim-stryke — filetype detection for stryke source
" Loaded automatically by pathogen / vim-plug / native packages via ftdetect/.

" By extension: every *.stk file is stryke.
autocmd BufNewFile,BufRead *.stk setfiletype stryke

" By shebang: files run as `#!/usr/bin/env stryke` (or a direct stryke path)
" with no .stk extension still light up. 5,951 .stk files in the wild use the
" env-stryke shebang, so honor it for extensionless scripts too.
autocmd BufNewFile,BufRead * call s:DetectStrykeShebang()

function! s:DetectStrykeShebang() abort
  if did_filetype() || &filetype ==# 'stryke'
    return
  endif
  let l:first = getline(1)
  if l:first =~# '^#!.*\<stryke\>'
    setfiletype stryke
  endif
endfunction
