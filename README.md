```
██╗   ██╗██╗███╗   ███╗      ███████╗████████╗██████╗ ██╗   ██╗██╗  ██╗███████╗
██║   ██║██║████╗ ████║      ██╔════╝╚══██╔══╝██╔══██╗╚██╗ ██╔╝██║ ██╔╝██╔════╝
██║   ██║██║██╔████╔██║█████╗███████╗   ██║   ██████╔╝ ╚████╔╝ █████╔╝ █████╗
╚██╗ ██╔╝██║██║╚██╔╝██║╚════╝╚════██║   ██║   ██╔══██╗  ╚██╔╝  ██╔═██╗ ██╔══╝
 ╚████╔╝ ██║██║ ╚═╝ ██║      ███████║   ██║   ██║  ██║   ██║   ██║  ██╗███████╗
  ╚═══╝  ╚═╝╚═╝     ╚═╝      ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
```

[![CI](https://github.com/MenkeTechnologies/vim-stryke/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/vim-stryke/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue.svg)](https://menketechnologies.github.io/vim-stryke/)
[![Report](https://img.shields.io/badge/report-engineering-cyan.svg)](https://menketechnologies.github.io/vim-stryke/report.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

### `[VIM PLUGIN // NEON SYNTAX // PERL-BASE GRAMMAR // STRYKE EXTENSIONS // ALE + LSP]`

 ┌──────────────────────────────────────────────────────────────┐
 │ STATUS: ONLINE &nbsp;&nbsp; FILETYPE: STRYKE &nbsp;&nbsp; SIGNAL: ████████░░ │
 └──────────────────────────────────────────────────────────────┘

> *"Load it with pathogen. Open a `.stk`. It lights up."*

---

## [0x00] OVERVIEW

**vim-stryke** is Vim / Neovim support for **[stryke](https://github.com/MenkeTechnologies/strykelang)** — a highly parallel Perl 5 interpreter written in Rust (a Perl 5 superset). It ships as a standard Vim runtime tree, so **pathogen / vim-plug / native packages** add it to `runtimepath` with zero special handling and zero configuration.

The design principle is faithfulness over reinvention: stryke's grammar is a **Perl 5 superset**, so the plugin loads Vim's full Perl **syntax** and **indent** engines as the base and layers only the stryke-specific extensions on top. Every extension keyword highlighted was **verified present in real `*.stk` source** — not invented from the language's design lineage. (The threading arrows from stryke's lineage — `->>`, `~>`, `|>` — were deliberately left out because they do not appear in actual stryke code.)

📖 **[Documentation](https://menketechnologies.github.io/vim-stryke/)** &middot; 🛠 **[Engineering report](https://menketechnologies.github.io/vim-stryke/report.html)**

Created by **[MenkeTechnologies](https://github.com/MenkeTechnologies)**.

---

## [0x01] FEATURE MATRIX

| Capability | Status |
|---|---|
| Filetype detection — `*.stk` | **Implemented** — every `*.stk` buffer becomes `filetype=stryke` |
| Filetype detection — shebang | **Implemented** — extensionless scripts with `#!/usr/bin/env stryke` are detected |
| Syntax highlighting | **Implemented** — full Perl syntax base + stryke extension keywords / types / builtins |
| Indentation | **Implemented** — reuses Vim's Perl indent engine (`autoindent` fallback) |
| Comments | **Implemented** — `commentstring=# %s`, comment-continuation `formatoptions` |
| Linting | **Implemented** — ALE linter running `stryke --lint` |
| Language server (vim-lsp) | **Implemented** — `stryke --lsp`, allowlisted for `stryke` + `perl` |
| Language server (coc.nvim) | **Implemented** — ready-to-paste `languageserver` config |
| Help | **Implemented** — `:help vim-stryke` |
| Config required | **None** — two opt-outs to disable ALE or LSP wiring |

> The `stryke` binary must be on `$PATH` for linting and LSP. `brew install stryke`, or build **[strykelang](https://github.com/MenkeTechnologies/strykelang)**.

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

## [0x03] SYNTAX // EXTENSION KEYWORDS

On top of the Perl base grammar, vim-stryke highlights the keywords stryke adds. **Every keyword below was verified present in real `*.stk` source.**

| Group | Keywords | Highlight |
|---|---|---|
| Declaration / structure | `fn` `typed` `const` `let` `module` `impl` `trait` `struct` `enum` | `Keyword` |
| Control flow | `match` `when` `then` `loop` `yield` `try` `catch` `finally` `defer` | `Keyword` |
| Concurrency | `async` `await` `spawn` `chan` | `Keyword` |
| Type names | `Int` `Str` `Float` `Bool` `Num` `Any` `Array` `Hash` `List` `Map` | `Type` |
| Print builtins | `p` `say` | `Function` |

These link to the standard `Keyword`, `Type`, and `Function` highlight groups, so every colorscheme covers them without bespoke tuning.

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
├── syntax/stryke.vim     # runtime! syntax/perl.vim + stryke extension keywords
├── ftplugin/stryke.vim   # commentstring '# %s', comments, formatoptions
├── indent/stryke.vim     # runtime! indent/perl.vim
├── plugin/stryke.vim     # ALE linter + vim-lsp + coc wiring
└── doc/stryke.txt        # :help vim-stryke
```

Standard Vim runtime layout — pathogen / vim-plug / native packages add it to `runtimepath` with no special handling.

---

## [0x08] LICENSE

MIT © **[MenkeTechnologies](https://github.com/MenkeTechnologies)**
