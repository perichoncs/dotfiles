# Keybindings Reference

Environment: **Cosmic DE** + **tmux** (prefix: `Ctrl-Space`) + **LazyVim** (leader: `Space`)

---

## Cosmic Desktop (Super key)

| Keybinding | Action |
|---|---|
| Super | Open app launcher |
| Super + Q | Close window |
| Super + M | Maximize/restore window |
| Super + Arrow keys | Tile window to half of screen |
| Super + 1-9 | Switch to workspace |
| Super + Shift + 1-9 | Move window to workspace |
| Super + T | Open terminal |
| Super + Tab | App switcher |

> Super key never reaches the terminal — zero conflict with tmux or Neovim.

---

## tmux (prefix: Ctrl-Space)

### Pane Management

| Keybinding | Action |
|---|---|
| Ctrl-Space, \| | Split pane vertically (side by side) |
| Ctrl-Space, - | Split pane horizontally (top/bottom) |
| Ctrl-h | Move to left pane (shared with Neovim via navigator) |
| Ctrl-j | Move to pane below |
| Ctrl-k | Move to pane above |
| Ctrl-l | Move to right pane |
| Ctrl-\\ | Move to last active pane |
| Ctrl-Space, H | Resize pane left by 5 |
| Ctrl-Space, J | Resize pane down by 5 |
| Ctrl-Space, K | Resize pane up by 5 |
| Ctrl-Space, L | Resize pane right by 5 |
| Ctrl-Space, x | Close current pane (with confirmation) |
| Ctrl-Space, z | Toggle pane zoom (fullscreen) |

### Window Management

| Keybinding | Action |
|---|---|
| Ctrl-Space, c | Create new window (in current path) |
| Alt-H | Previous window |
| Alt-L | Next window |
| Ctrl-Space, , | Rename current window |
| Ctrl-Space, & | Close current window (with confirmation) |
| Ctrl-Space, 1-9 | Jump to window number |

### Session Management

| Keybinding | Action |
|---|---|
| Ctrl-Space, S | Create new session |
| Ctrl-Space, s | List/switch sessions |
| Ctrl-Space, $ | Rename current session |
| Ctrl-Space, d | Detach from session |

### Copy Mode (vi-style)

| Keybinding | Action |
|---|---|
| Ctrl-Space, [ | Enter copy mode |
| v (in copy mode) | Begin selection |
| y (in copy mode) | Copy selection to clipboard |
| q (in copy mode) | Exit copy mode |

### Misc

| Keybinding | Action |
|---|---|
| Ctrl-Space, r | Reload tmux config |
| Ctrl-Space, I | Install TPM plugins |
| Ctrl-Space, U | Update TPM plugins |

---

## LazyVim / Neovim (leader: Space)

### File & Navigation

| Keybinding | Action |
|---|---|
| Space Space | Find files (Telescope) |
| Space / | Grep text across project |
| Space , | Switch between open buffers |
| Space e | Toggle file explorer (Neo-tree) |
| Space E | File explorer (cwd) |
| Space f f | Find files |
| Space f r | Recent files |

### Windows & Splits

| Keybinding | Action |
|---|---|
| Ctrl-h/j/k/l | Navigate between splits (shared with tmux) |
| Space \| | Vertical split |
| Space - | Horizontal split |
| Space w d | Close current split |
| Space w w | Switch to other split |

### Buffers

| Keybinding | Action |
|---|---|
| Space b d | Delete buffer |
| Space b b | Switch buffer |
| [ b | Previous buffer |
| ] b | Next buffer |

### Terminal

| Keybinding | Action |
|---|---|
| Ctrl-/ | Toggle floating terminal |
| :vsplit + :terminal | Terminal in side split |
| :split + :terminal | Terminal in bottom split |
| Ctrl-\\ Ctrl-n | Exit terminal insert mode |

### Code

| Keybinding | Action |
|---|---|
| g d | Go to definition |
| g r | Go to references |
| K | Hover documentation |
| Space c a | Code actions |
| Space c r | Rename symbol |
| Space c d | Line diagnostics |
| [ d / ] d | Previous/next diagnostic |

### Save & Quit

| Keybinding | Action |
|---|---|
| Space w | Save file |
| Space q | Quit window |
| Space Q | Quit all |

### Search & Replace

| Keybinding | Action |
|---|---|
| Space s g | Grep (search) |
| Space s r | Search and replace (Spectre) |
| Space s s | Search symbols in buffer |

### Git (via LazyGit)

| Keybinding | Action |
|---|---|
| Space g g | Open LazyGit |
| Space g b | Git blame line |
| ] h / [ h | Next/previous hunk |

### Lazy Plugin Manager

| Keybinding | Action |
|---|---|
| Space l | Open Lazy plugin manager |

---

## Key Layering Summary

```
┌──────────────────────────────────────────────┐
│  Cosmic DE      →  Super + ...               │
│  tmux           →  Ctrl-Space + ...          │
│  Neovim/LazyVim →  Space + ...               │
│  Shared         →  Ctrl-h/j/k/l (navigator)  │
└──────────────────────────────────────────────┘
```

No layer conflicts with this setup.

---

## Dotfiles Management (GNU Stow)

Install stow and re-link (from a real terminal, not VS Code Flatpak):

```bash
sudo apt install stow
cd ~/dotfiles
stow tmux    # creates ~/.tmux.conf → dotfiles/tmux/.tmux.conf
stow nvim    # creates ~/.config/nvim → dotfiles/nvim/.config/nvim
```

Push to GitHub:

```bash
cd ~/dotfiles
git init
git add .
git commit -m "initial dotfiles"
gh repo create dotfiles --public --source=. --push
# or: git remote add origin git@github.com:YOUR_USER/dotfiles.git && git push -u origin main
```
