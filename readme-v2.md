# dotfiles v2 — Changelog & Guide

This document describes all changes introduced in the **v2-tooling** update.

---

## What changed

### New language support

| Language | What was added |
|---|---|
| **Rust** | LazyVim `lang.rust` + `lang.toml` extras, `rust-analyzer` via Mason, Rust installed via `rustup` |
| **Go** | *(already present)* — now also installed by `bootstrap.sh` via official tarball |
| **Python** | *(already present)* — added `ruff` (linter/formatter) to bootstrap + Mason, `python3` installed by bootstrap |

### New tools added to bootstrap.sh

| Tool | Purpose |
|---|---|
| **ruff** | Fast Python linter & formatter — fixes the LazyVim errors on startup |
| **lazygit** | Terminal Git UI — required by LazyVim's `<Space>gg` keybind |
| **bat** | Syntax-highlighted `cat` — great for file previewing and fzf integration |
| **fzf** | Fuzzy finder — powers zoxide's `zi` interactive mode and general terminal search |
| **go** | Go compiler & tools — installed from official tarball to `/usr/local/go` |
| **rust** | Rust toolchain — installed via `rustup` (rustc, cargo, rustup) |
| **python3** | Python 3 + pip + venv — base for ruff and Python development |

### tmux session persistence (configured)

`tmux-resurrect` and `tmux-continuum` were already installed as plugins but had no configuration.
Now they are fully configured:

| Setting | Value | Effect |
|---|---|---|
| `@continuum-restore` | `on` | Automatically restore last session when tmux starts |
| `@continuum-save-interval` | `15` | Auto-save session every 15 minutes |
| `@resurrect-capture-pane-contents` | `on` | Save pane contents (scrollback) with the session |

**New keybindings:**

| Keybinding | Action |
|---|---|
| Ctrl-Space, Ctrl-s | Manually save session |
| Ctrl-Space, Ctrl-r | Manually restore session |

A new plugin was also added: **tmux-yank** — improved copy-paste in tmux copy mode.

### LazyVim extras added

| Extra | Purpose |
|---|---|
| `lang.rust` | rust-analyzer LSP, rustfmt, Cargo integration |
| `lang.toml` | TOML support (syntax, LSP) — essential for `Cargo.toml` |

### Mason ensure_installed additions

- `ruff` — Python linter/formatter (eliminates LazyVim startup errors)
- `rust-analyzer` — Rust LSP server

### New: uninstall.sh

A new `uninstall.sh` script allows you to cleanly remove everything for a fresh re-install:

```bash
# Remove symlinks, configs, plugin data (keeps installed programs)
bash uninstall.sh

# Remove EVERYTHING including installed programs
bash uninstall.sh --full

# Then re-install from scratch
bash bootstrap.sh
```

**What it removes:**
- Stow symlinks (tmux, nvim, zsh)
- TPM and all tmux plugins
- Neovim plugin data, Mason installs, caches
- Oh My Zsh and custom plugins
- Restores any `.bak` config files
- With `--full`: all programs installed by bootstrap (Go, Rust, Neovim, lazygit, etc.)

---

## Updated tool table

| Category | Tools |
|---|---|
| **Shell** | Zsh + Oh My Zsh + Powerlevel10k + MesloLGS NF |
| **Editor** | Neovim (LazyVim) |
| **Terminal multiplexer** | tmux (prefix: `Ctrl-Space`) + TPM |
| **Shell utilities** | zoxide, ripgrep, fd, eza, glow, jq, xclip, bat, fzf |
| **Dev tooling** | GitHub CLI (`gh`), Doppler (secrets), lazygit |
| **Languages** | Go, Rust (rustup), Python 3 |
| **Linting/Formatting** | ruff (Python) |
| **Dotfiles management** | GNU Stow |

---

## Language workflows

### Go

- **LSP:** gopls (via Mason)
- **Extra tooling:** ray-x/go.nvim — `<leader>cgs` fill struct, `<leader>cge` if-err, etc.
- **Debugging:** delve via nvim-dap (`<Space>db` breakpoint, `<Space>dc` continue)
- **Testing:** neotest (`<Space>tr` run nearest test)

### Rust

- **LSP:** rust-analyzer (via Mason)
- **Formatting:** rustfmt (automatic on save via LazyVim)
- **Code actions:** `<Space>ca` — auto-import, fill match arms, unwrap Result, etc.
- **Debugging:** codelldb via nvim-dap
- **TOML:** Full `Cargo.toml` support via `lang.toml` extra

### Python

- **LSP:** basedpyright (via Mason)
- **Linting/Formatting:** ruff (via Mason) — replaces flake8, isort, black in one tool
- **Debugging:** debugpy via nvim-dap
- **Testing:** neotest with pytest adapter

---

## Files changed

```
modified:  bootstrap.sh                              # added 7 new installers
modified:  programs-installed.md                      # added ruff, lazygit, bat, fzf, go, rust, python3
modified:  tmux/.tmux.conf                            # session persistence config + tmux-yank
modified:  nvim/.config/nvim/lua/plugins/devops.lua   # Rust + TOML extras, ruff + rust-analyzer in Mason
modified:  nvim/.config/nvim/lazyvim.json             # added lang.rust, lang.toml extras
modified:  keybindings.md                             # Rust keybindings + session persistence keys
new:       uninstall.sh                               # clean removal script
new:       readme-v2.md                               # this file
```
