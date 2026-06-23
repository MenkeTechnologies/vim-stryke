```
██╗   ██╗██╗███╗   ███╗      ███████╗████████╗██████╗ ██╗   ██╗██╗  ██╗███████╗
██║   ██║██║████╗ ████║      ██╔════╝╚══██╔══╝██╔══██╗╚██╗ ██╔╝██║ ██╔╝██╔════╝
██║   ██║██║██╔████╔██║█████╗███████╗   ██║   ██████╔╝ ╚████╔╝ █████╔╝ █████╗
╚██╗ ██╔╝██║██║╚██╔╝██║╚════╝╚════██║   ██║   ██╔══██╗  ╚██╔╝  ██╔═██╗ ██╔══╝
 ╚████╔╝ ██║██║ ╚═╝ ██║      ███████║   ██║   ██║  ██║   ██║   ██║  ██╗███████╗
  ╚═══╝  ╚═╝╚═╝     ╚═╝      ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
```

[![CI](https://github.com/MenkeTechnologies/vim-stryke/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/vim-stryke/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-online-blue.svg)](https://menketechnologies.github.io/vim-stryke/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

### `[VIM PLUGIN // NEON SYNTAX // STANDALONE STRYKE GRAMMAR // ALE + LSP]`

> *"Load it with pathogen. Open a `.stk`. It lights up."*

Vim / Neovim support for **[stryke](https://github.com/MenkeTechnologies/strykelang)** — a highly parallel Perl 5 superset interpreter written in Rust. Standalone syntax highlighting, filetype detection, brace-aware indentation, ALE linting, and vim-lsp / coc.nvim integration. Zero configuration.

```bash
cd ~/.vim/bundle && git clone https://github.com/MenkeTechnologies/vim-stryke   # pathogen
```

### [`Read the Docs`](https://menketechnologies.github.io/vim-stryke/) &middot; [`Engineering Report`](https://menketechnologies.github.io/vim-stryke/report.html) · [`strykelang`](https://github.com/MenkeTechnologies/strykelang) · [`zshrs`](https://github.com/MenkeTechnologies/zshrs)

---

## [0x00] OVERVIEW

**vim-stryke** is Vim / Neovim support for **stryke** — a highly parallel Perl 5 superset interpreter written in Rust. It ships as a standard Vim runtime tree, so **pathogen / vim-plug / native packages** add it to `runtimepath` with zero special handling and zero configuration.

The syntax file is a **standalone stryke grammar** — not a reskin of Vim's `perl` syntax. Its token categories, keyword sets, builtin lists, and word operators are derived directly from stryke's own canonical sources:

- `strykelang/strykelang/token.rs` — the lexer and its `KEYWORDS` table
- `strykelang/editors/intellij/.../StrykeLexer.kt` — the `DECL` / `FN` / `CONTROL` / `PHASE` / `WORD_OPERATOR` / `BOOLEAN` / `PARALLEL_BUILTINS` / `BUILTINS` category sets

The highlight categories mirror the official IntelliJ plugin's color slots, so both editors agree on what each token is.

> The `stryke` binary must be on `$PATH` for linting and LSP. `brew install stryke`, or build **[strykelang](https://github.com/MenkeTechnologies/strykelang)**.

---

## [0x01] FEATURE MATRIX

| Capability | Status |
|---|---|
| Filetype detection — `*.stk` | **Implemented** — every `*.stk` buffer becomes `filetype=stryke` |
| Filetype detection — shebang | **Implemented** — extensionless scripts with `#!/usr/bin/env stryke` are detected |
| Syntax highlighting | **Implemented** — standalone grammar from stryke's lexer (keywords, builtins, parallel builtins, sigils, strings, here-docs, regex, thread macros) |
| Indentation | **Implemented** — standalone brace-aware indenter |
| Comments | **Implemented** — `commentstring=# %s`, POD blocks, comment-continuation `formatoptions` |
| Linting | **Implemented** — ALE linter running `stryke --lint` |
| Language server (vim-lsp) | **Implemented** — `stryke --lsp`, allowlisted for `stryke` + `perl` |
| Language server (coc.nvim) | **Implemented** — ready-to-paste `languageserver` config |
| Help | **Implemented** — `:help vim-stryke` |
| Config required | **None** — two opt-outs to disable ALE or LSP wiring |

---

## [0x02] INSTALL

**pathogen**

```bash
cd ~/.vim/bundle
git clone https://github.com/MenkeTechnologies/vim-stryke
# then inside vim:  :Helptags
```

**vim-plug** (add to `~/.vimrc` / `init.vim`)

```vim
Plug 'MenkeTechnologies/vim-stryke'
```

**native packages** (Vim 8+ / Neovim)

```bash
git clone https://github.com/MenkeTechnologies/vim-stryke \
    ~/.vim/pack/plugins/start/vim-stryke
```

Open any `.stk` file and it lights up — no further configuration. See `:help vim-stryke`.

---

## [0x03] SYNTAX // TOKEN CATEGORIES

The grammar classifies tokens into the same categories the official stryke lexer uses:

| Category | Tokens (sample) | Highlight |
|---|---|---|
| Declarations | `my` `var` `val` `our` `local` `state` `const` `typed` `use` `package` `pub` `is` `as` | `StorageClass` |
| Function / type introducers | `fn` `sub` `method` `class` `trait` `struct` `enum` `impl` `extends` | `Keyword` |
| Control flow | `if` `elsif` `else` `unless` `while` `until` `loop` `for` `foreach` `match` `when` `try` `catch` `finally` `defer` | `Statement` |
| Phase / block hooks | `BEGIN` `END` `INIT` `CHECK` `UNITCHECK` `BUILD` `DESTROY` | `PreProc` |
| Word operators | `and` `or` `not` `xor` `cmp` `eq` `ne` `lt` `le` `gt` `ge` `x` | `Operator` |
| Booleans / undef | `true` `false` `undef` `null` | `Boolean` / `Constant` |
| Parallel builtins | `pmap` `pgrep` `pfor` `ploop` `pwhile` `spawn` `async` `await` `channel` | `Function` |
| Builtins | `p` `say` `print` `map` `grep` `reduce` `fold` `json_encode` `sha256` `fetch` `ai` … | `Function` |
| Type names | `Int` `Str` `Float` `Bool` `Num` `Any` `Array` `Hash` `List` `Map` `Set` `Void` | `Type` |
| Thread macros | `~>` `~>>` `->>` `\|>` (plus streaming `~s>`, parallel `~p>`, distributed `~d>` variants) | `Operator` |

Sigil variables (`$scalar` / `@array` / `%hash`, the `$_` topic, special punctuation vars), single / double / backtick strings with interpolation and escapes, `qw//` and `q//` / `qq//` quotes, here-docs, and `m//` / `s///` / `tr///` / `qr//` regex are all handled. Everything links to standard highlight groups, so every colorscheme covers it.

---

## [0x04] LINTING (ALE)

When **[ALE](https://github.com/dense-analysis/ale)** is installed, vim-stryke registers a linter that runs:

```bash
stryke --lint %t
```

Diagnostics of the form `<message> at <file> line <n>` are surfaced inline. Skipped silently if ALE is absent or `g:vim_stryke_no_ale` is set.

---

## [0x05] LANGUAGE SERVER

### vim-lsp

Registered automatically as `stryke --lsp`, allowlisted for the `stryke` and `perl` filetypes — no extra config when **[vim-lsp](https://github.com/prabirshrestha/vim-lsp)** is installed.

### coc.nvim

Add to `coc-settings.json`:

```json
{
  "languageserver": {
    "stryke": {
      "command": "stryke",
      "args": ["--lsp"],
      "filetypes": ["stryke", "perl"]
    }
  }
}
```

---

## [0x06] OPTIONS

Set before the plugin loads (e.g. in your `vimrc`):

| Variable | Effect |
|---|---|
| `let g:vim_stryke_no_ale = 1` | Skip ALE linter registration |
| `let g:vim_stryke_no_lsp = 1` | Skip vim-lsp server registration |

---

## [0x07] LAYOUT

```
vim-stryke/
├── ftdetect/stryke.vim   # *.stk + #!/usr/bin/env stryke -> filetype=stryke
├── syntax/stryke.vim     # standalone stryke grammar (from token.rs + StrykeLexer.kt)
├── ftplugin/stryke.vim   # commentstring '# %s', comments, formatoptions
├── indent/stryke.vim     # standalone brace-aware indenter
├── plugin/stryke.vim     # ALE linter + vim-lsp + coc wiring
└── doc/stryke.txt        # :help vim-stryke
```

Standard Vim runtime layout — pathogen / vim-plug / native packages add it to `runtimepath` with no special handling.

---

## [0x08] LICENSE

MIT © **[MenkeTechnologies](https://github.com/MenkeTechnologies)**
