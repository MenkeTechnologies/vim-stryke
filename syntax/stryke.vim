" vim-stryke — syntax highlighting for the stryke language
"
" A standalone stryke grammar — NOT a reskin of Vim's perl syntax. The token
" categories, keyword sets, builtin lists, and word operators below are taken
" directly from the canonical stryke sources:
"   - strykelang/strykelang/token.rs            (lexer / KEYWORDS)
"   - strykelang/editors/intellij/.../StrykeLexer.kt  (DECL/FN/CONTROL/PHASE/
"     WORD_OPERATOR/BOOLEAN/PARALLEL_BUILTINS/BUILTINS category sets)
"
" Highlight categories mirror the official IntelliJ plugin's color slots so the
" two editors agree on what each token is.

if exists('b:current_syntax')
  finish
endif

syntax case match
syntax sync minlines=50

" ---------------------------------------------------------------------------
" Comments / POD / shebang
" ---------------------------------------------------------------------------
syntax keyword strykeTodo contained TODO FIXME XXX NOTE HACK
syntax match   strykeComment "#.*$" contains=strykeTodo,@Spell
syntax match   strykeShebang "\%^#!.*$"
" POD documentation blocks: =pod ... =cut (and any =command line).
syntax region  strykePod start="^=\a" end="^=cut\>" end="\%$" contains=strykeTodo,@Spell

" ---------------------------------------------------------------------------
" Numbers
" ---------------------------------------------------------------------------
syntax match strykeNumber "\<\d\+\%(_\d\+\)*\>"
syntax match strykeNumber "\<0x\x\+\>"
syntax match strykeNumber "\<0b[01]\+\>"
syntax match strykeNumber "\<0o\?\o\+\>"
syntax match strykeFloat  "\<\d\+\%(_\d\+\)*\.\d\+\%([eE][-+]\?\d\+\)\?\>"
syntax match strykeFloat  "\<\d\+[eE][-+]\?\d\+\>"

" ---------------------------------------------------------------------------
" Variables (sigils)
" ---------------------------------------------------------------------------
" Topic / special punctuation vars first (most specific).
syntax match strykeTopicVar  "\$_\>"
syntax match strykeSpecialVar "\$[!@/\\&`'+0-9.,;^]"
syntax match strykeSpecialVar "@_\>"
syntax match strykeSpecialVar "\$#\h\w*"
" Scalar / array / hash identifiers (incl. package-qualified a::b).
syntax match strykeScalar "\$\$\?\h\w*\%(::\h\w*\)*"
syntax match strykeArray  "@\$\?\h\w*\%(::\h\w*\)*"
syntax match strykeHash   "%\$\?\h\w*\%(::\h\w*\)*"

" ---------------------------------------------------------------------------
" Strings
" ---------------------------------------------------------------------------
syntax match  strykeStringEscape contained "\\."
syntax match  strykeInterp contained "\$\h\w*\%(::\h\w*\)*"
syntax match  strykeInterp contained "@\h\w*"
syntax region strykeInterp contained matchgroup=strykeInterp start="\${" end="}" contains=TOP

syntax region strykeStringS  start=+'+ skip=+\\'+ end=+'+ contains=strykeStringEscape
syntax region strykeStringD  start=+"+ skip=+\\"+ end=+"+ contains=strykeStringEscape,strykeInterp,@Spell
syntax region strykeBacktick start=+`+ skip=+\\`+ end=+`+ contains=strykeStringEscape,strykeInterp

" qw// word lists and q// qq// generic quotes (common delimiters).
syntax region strykeQw start=+\<qw\s*(+ end=+)+ contains=NONE
syntax region strykeQw start=+\<qw\s*{+ end=+}+ contains=NONE
syntax region strykeQw start=+\<qw\s*\[+ end=+\]+ contains=NONE
syntax region strykeQw start=+\<qw\s*/+ end=+/+ contains=NONE
syntax region strykeStringD start=+\<qq\s*(+ end=+)+ contains=strykeStringEscape,strykeInterp
syntax region strykeStringD start=+\<qq\s*{+ end=+}+ contains=strykeStringEscape,strykeInterp
syntax region strykeStringS start=+\<q\s*(+ end=+)+ contains=strykeStringEscape
syntax region strykeStringS start=+\<q\s*{+ end=+}+ contains=strykeStringEscape

" Heredocs: <<EOF, <<"EOF", <<'EOF', <<~EOF (indented).
syntax region strykeHereDoc matchgroup=strykeStringD start=+<<\~\?"\=\z(\h\w*\)"\=+ end=+^\s*\z1$+ contains=strykeInterp,strykeStringEscape
syntax region strykeHereDoc matchgroup=strykeStringS start=+<<\~\?'\z(\h\w*\)'+ end=+^\s*\z1$+

" ---------------------------------------------------------------------------
" Regex
" ---------------------------------------------------------------------------
syntax match  strykeRegexBind "=\~\|!\~"
syntax region strykeRegex matchgroup=strykeRegexDelim start=+\<m\s*/+ skip=+\\/+ end=+/[a-z]*+
syntax region strykeRegex matchgroup=strykeRegexDelim start=+\<qr\s*/+ skip=+\\/+ end=+/[a-z]*+
syntax region strykeRegex matchgroup=strykeRegexDelim start=+\<s\s*/+ skip=+\\/+ end=+/[a-z]*+
syntax region strykeRegex matchgroup=strykeRegexDelim start=+\<\%(tr\|y\)\s*/+ skip=+\\/+ end=+/[a-z]*+

" ---------------------------------------------------------------------------
" Keyword categories (verbatim from StrykeLexer.kt category sets)
" ---------------------------------------------------------------------------
" Declarations
syntax keyword strykeDecl my var val our oursync local state const frozen typed
syntax keyword strykeDecl use no import package require has pub priv in is as
" Function / type introducers
syntax keyword strykeFnKeyword fn sub method class trait struct enum impl extends
" Control flow
syntax keyword strykeControl return if elsif else unless while until loop
syntax keyword strykeControl for foreach do last next redo continue goto
syntax keyword strykeControl given when default match
syntax keyword strykeControl die eval try catch finally defer
" Phase / block hooks
syntax keyword strykePhase BEGIN END INIT CHECK UNITCHECK BUILD DESTROY
" Booleans / undef
syntax keyword strykeBoolean true false
syntax keyword strykeUndef undef null
" Word operators
syntax keyword strykeWordOp and or not xor cmp eq ne lt le gt ge x
" Magic constants
syntax match strykeMagic "\<__\%(FILE\|LINE\|PACKAGE\|SUB\|DATA\|END\)__\>"

" ---------------------------------------------------------------------------
" Builtins
" ---------------------------------------------------------------------------
" Parallel primitives (their own color slot in the official highlighter)
syntax keyword strykeBuiltinPar pmap pgrep pfor pforeach ploop pwhile pflat_map
syntax keyword strykeBuiltinPar pmaps pgreps pflat_maps par_fetch par_each par_run par_apply
syntax keyword strykeBuiltinPar channel spawn await async mysync varsync

syntax keyword strykeBuiltin p ep say print printf warn len scalar keys values
syntax keyword strykeBuiltin each push pop shift unshift splice reverse sort join
syntax keyword strykeBuiltin split map grep fi reduce fold filter take skip
syntax keyword strykeBuiltin tap open close read write chomp chop exists defined
syntax keyword strykeBuiltin delete wantarray ref bless tie tied untie
syntax keyword strykeBuiltin json_encode json_decode tj fj yaml_encode yaml_decode
syntax keyword strykeBuiltin xml_encode xml_decode csv_encode csv_decode toml_encode toml_decode
syntax keyword strykeBuiltin fetch http_request hr serve websocket
syntax keyword strykeBuiltin jwt_encode jwt_decode sha256 sha512 md5 hmac
syntax keyword strykeBuiltin ai embedding complete
syntax keyword strykeBuiltin time sleep log_json set pipeline to_set uniq
syntax keyword strykeBuiltin regex subst lc uc lcfirst ucfirst sprintf
syntax keyword strykeBuiltin int abs sqrt exp log sin cos tan atan2 rand
syntax keyword strykeBuiltin srand min max sum mean median stddev variance
syntax keyword strykeBuiltin snake_case sc camel_case cc pascal_case kebab_case
syntax keyword strykeBuiltin spurt slurp exists_file exists_dir mkdir_p rmdir_r now_ns td_add
" GUI automation builtins (builtins_gui.rs)
syntax keyword strykeBuiltin mouse_pos mouse_size screen_size on_screen
syntax keyword strykeBuiltin mouse_move mouse_move_rel mouse_drag mouse_drag_rel
syntax keyword strykeBuiltin mouse_click mouse_right_click mouse_middle_click
syntax keyword strykeBuiltin mouse_double_click mouse_triple_click mouse_down mouse_up
syntax keyword strykeBuiltin mouse_scroll mouse_vscroll mouse_hscroll
syntax keyword strykeBuiltin key_press key_down key_up key_type key_hotkey keyboard_keys
syntax keyword strykeBuiltin pixel pixel_matches_color screenshot screenshot_region

" ---------------------------------------------------------------------------
" Optional type names (typed my $x : Int|Str|Float ; fn ($a: Int) {})
" ---------------------------------------------------------------------------
syntax keyword strykeType Int Str Float Bool Num Any Array Hash List Map Set Void

" ---------------------------------------------------------------------------
" Operators (sigil-level, thread macros, arrows, ranges)
" ---------------------------------------------------------------------------
syntax match strykeThreadArrow "\~p\?d\?s\?>>\?\|->>"
syntax match strykeOperator    "|>\|=>\|->\|\.\.\.\?\|::"
syntax match strykeOperator    "[-+*/%.]=\?\|\*\*\|==\|!=\|<=>\|<=\|>=\|<\|>\|&&\|||\|//\|!\|?\|\\"

" ---------------------------------------------------------------------------
" Highlight links — map stryke groups onto standard groups so every
" colorscheme covers them.
" ---------------------------------------------------------------------------
highlight default link strykeComment      Comment
highlight default link strykeShebang      PreProc
highlight default link strykePod          Comment
highlight default link strykeTodo         Todo
highlight default link strykeNumber       Number
highlight default link strykeFloat        Float
highlight default link strykeTopicVar     Special
highlight default link strykeSpecialVar   Special
highlight default link strykeScalar       Identifier
highlight default link strykeArray        Identifier
highlight default link strykeHash         Identifier
highlight default link strykeStringS      String
highlight default link strykeStringD      String
highlight default link strykeBacktick     String
highlight default link strykeQw           String
highlight default link strykeHereDoc      String
highlight default link strykeStringEscape SpecialChar
highlight default link strykeInterp       Identifier
highlight default link strykeRegex        String
highlight default link strykeRegexDelim   Delimiter
highlight default link strykeRegexBind    Operator
highlight default link strykeDecl         StorageClass
highlight default link strykeFnKeyword    Keyword
highlight default link strykeControl      Statement
highlight default link strykePhase        PreProc
highlight default link strykeBoolean      Boolean
highlight default link strykeUndef        Constant
highlight default link strykeWordOp       Operator
highlight default link strykeMagic        Constant
highlight default link strykeBuiltin      Function
highlight default link strykeBuiltinPar   Function
highlight default link strykeType         Type
highlight default link strykeThreadArrow  Operator
highlight default link strykeOperator     Operator

let b:current_syntax = 'stryke'
