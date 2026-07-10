# AGENTS.md

## Repo overview

Personal dotfiles managed with GNU Stow. Repo must live at `~/dev/dotfiles` — the Makefile hardcodes `DOTFILES_DIR ?= $(HOME)/dev/dotfiles` and stow targets `$(HOME)`.

## Stow layout

Each top-level directory is a stow package. Running `stow <pkg> -t $(HOME)` symlinks its contents into `$HOME`, preserving the directory tree. For example, `nvim/.config/nvim/` becomes `~/.config/nvim/`.

Packages: `zsh`, `nvim`, `kitty`, `i3`

## Installation

```bash
make          # full setup (homebrew → deps → stow → all packages → languages)
```

Individual targets:
```bash
make configure-nvim    # stow nvim only
make configure-zsh     # stow zsh only
make configure-kitty   # stow kitty only
make configure-i3      # stow i3 only (linux only, no-op on macOS)
```

## Platform behavior

`PLATFORM` is auto-detected via `uname`. Several targets are Linux/Arch-only (`i3`, `install-zsh`, `install-nvim` via pacman). On macOS, deps come from Homebrew (`scripts/brew-deps.sh` installs ripgrep, fzf, and Fira Mono Nerd Font).

## Language tooling

Languages (Node, Go, Elixir, Gleam, Rust) are installed via asdf. Versions are always `latest` at install time — no `.tool-versions` pinning.

## Neovim config

- Entry point: `nvim/.config/nvim/init.lua` — loads `skink-vim` module
- Plugin manager: **lazy.nvim** (not packer). After adding plugins, run `:Lazy sync` in nvim
- Plugin specs live in `nvim/.config/nvim/lua/skink-vim/lazy.lua`; lazy.nvim auto-bootstraps from GitHub on first launch
- Per-plugin config lives in `nvim/.config/nvim/after/plugin/` — one file per plugin
- `lazy-lock.json` is committed — update it deliberately with `:Lazy update`
- `plugin/` directory is gitignored — it's generated at runtime by lazy
- Requires Neovim 0.7+; currently running 0.10/0.11 — nvim-treesitter is pinned to `branch = 'master'` because the `main` branch requires 0.11+
- LSP via `lsp-zero` + Mason; extra formatters/linters via `none-ls` (nvimtools fork of null-ls)
- DAP configured for Go (`nvim-dap-go`)

## CI

`push.yml` runs `make` on both macOS and Arch Linux (via Docker). The Dockerfile is Arch-based and pre-syncs the package database. There are no unit tests — CI validates the full install completes without error.
