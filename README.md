# vim-stryke

[![CI](https://github.com/MenkeTechnologies/vim-stryke/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/vim-stryke/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue.svg)](https://menketechnologies.github.io/vim-stryke/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Vim / Neovim support for **[stryke](https://github.com/MenkeTechnologies/strykelang)** — a highly parallel Perl 5 interpreter written in Rust (a Perl 5 superset). Load it with pathogen and get full stryke support in the editor: filetype detection, syntax highlighting, indentation, linting, and language-server integration.

📖 **[Documentation site](https://menketechnologies.github.io/vim-stryke/)**

## Features

- **Filetype detection** — every `*.stk` file becomes `filetype=stryke`; extensionless scripts with a `#!/usr/bin/env stryke` shebang are detected too.
- **Syntax highlighting** — Vim's full Perl syntax loads as the base, then stryke's extension keywords, type names, and print builtins are layered on top.
- **Indentation** — reuses Vim's Perl indent engine (stryke's block grammar is Perl's).
- **Linting (ALE)** — runs `stryke --lint` and surfaces diagnostics inline.
- **Language server** — registers `stryke --lsp` for [vim-lsp](https://github.com/prabirshrestha/vim-lsp) and coc.nvim.
- **Zero config** — no settings required; two opt-outs to disable ALE or LSP wiring.

## Requirements

The `stryke` binary must be on your `$PATH` for linting and LSP. Install it via Homebrew or build [strykelang](https://github.com/MenkeTechnologies/strykelang):

```sh
brew install stryke
```

## Installation

### pathogen

```sh
cd ~/.vim/bundle
git clone https://github.com/MenkeTechnologies/vim-stryke
```

Then inside Vim, generate help tags:

```vim
:Helptags
```

### vim-plug

```vim
Plug 'MenkeTechnologies/vim-stryke'
```

### Native packages (Vim 8+ / Neovim)

```sh
git clone https://github.com/MenkeTechnologies/vim-stryke \
    ~/.vim/pack/plugins/start/vim-stryke
```

Open any `.stk` file and it lights up — no further configuration. See `:help vim-stryke`.

## Syntax — stryke extension keywords

On top of the Perl base grammar, vim-stryke highlights the keywords stryke adds. Every keyword below was verified present in real `*.stk` source:

| Group | Keywords |
| --- | --- |
| Declaration / structure | `fn` `typed` `const` `let` `module` `impl` `trait` `struct` `enum` |
| Control flow | `match` `when` `then` `loop` `yield` `try` `catch` `finally` `defer` |
| Concurrency | `async` `await` `spawn` `chan` |
| Type names | `Int` `Str` `Float` `Bool` `Num` `Any` `Array` `Hash` `List` `Map` |
| Print builtins | `p` `say` |

These link to the standard `Keyword`, `Type`, and `Function` highlight groups, so every colorscheme covers them.

## Linting (ALE)

When [ALE](https://github.com/dense-analysis/ale) is installed, vim-stryke registers a linter that runs:

```sh
stryke --lint %t
```

Diagnostics of the form `<message> at <file> line <n>` are surfaced inline.

## Language server

### vim-lsp

Registered automatically as `stryke --lsp`, allowlisted for the `stryke` and `perl` filetypes — no extra config needed when [vim-lsp](https://github.com/prabirshrestha/vim-lsp) is installed.

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

## Options

Set these before the plugin loads (e.g. in your `vimrc`):

| Variable | Effect |
| --- | --- |
| `let g:vim_stryke_no_ale = 1` | Skip ALE linter registration |
| `let g:vim_stryke_no_lsp = 1` | Skip vim-lsp server registration |

## Layout

```
vim-stryke/
├── ftdetect/stryke.vim   # *.stk + #!/usr/bin/env stryke -> filetype=stryke
├── syntax/stryke.vim     # runtime! syntax/perl.vim + stryke extension keywords
├── ftplugin/stryke.vim   # commentstring '# %s', comments, formatoptions
├── indent/stryke.vim     # runtime! indent/perl.vim
├── plugin/stryke.vim     # ALE linter + vim-lsp + coc wiring
└── doc/stryke.txt        # :help vim-stryke
```

## License

MIT © [MenkeTechnologies](https://github.com/MenkeTechnologies)
