# dotfiles

Personal development environment managed with [GNU Stow](https://www.gnu.org/software/stow/) and automated via a single bootstrap script.

## What's included

| Category | Tools |
|---|---|
| **Shell** | Zsh + Oh My Zsh + Powerlevel10k + MesloLGS NF |
| **Editor** | Neovim (LazyVim) |
| **Terminal multiplexer** | tmux (prefix: `Ctrl-Space`) + TPM |
| **Shell utilities** | zoxide, ripgrep, fd, eza, glow, jq, xclip |
| **Dev tooling** | GitHub CLI (`gh`), Doppler (secrets) |
| **Dotfiles management** | GNU Stow |

The full list lives in [`programs-installed.md`](programs-installed.md) — the bootstrap script reads it automatically.

## Quick start — fresh AWS instance (or any Ubuntu/Debian machine)

SSH into your new instance and run **one command**:

```bash
# One-liner: clone + bootstrap (uses apt on Ubuntu/Debian)
git clone https://github.com/perichoncs/dotfiles.git ~/dotfiles \
  && cd ~/dotfiles \
  && bash bootstrap.sh
```

> **No `git`?** The script installs `git` and `curl` first if they're missing, so on a truly bare instance you can also do:
>
> ```bash
> sudo apt-get update && sudo apt-get install -y git
> git clone https://github.com/perichoncs/dotfiles.git ~/dotfiles
> cd ~/dotfiles && bash bootstrap.sh
> ```

### What the bootstrap script does

1. **Installs prerequisites** — ensures `git` and `curl` are present.
2. **Clones this repo** to `~/dotfiles` (skipped if already there).
3. **Installs every program** listed in `programs-installed.md` (zsh, Neovim, tmux, ripgrep, zoxide, fd, eza, glow, gh, jq, doppler, xclip, stow).
4. **Sets up Zsh** — Oh My Zsh, Powerlevel10k theme, zsh-autosuggestions, zsh-syntax-highlighting, and MesloLGS Nerd Font.
5. **Symlinks configs** via `stow tmux`, `stow nvim`, and `stow zsh` into their home directory locations.
6. **Installs TPM** (tmux plugin manager).
7. **Sets zsh as default shell**.
8. Prints **next steps** you need to run manually.

### After bootstrap — manual steps

```bash
# 1. Install tmux plugins
tmux                             # start tmux
# Press Ctrl-Space + I           # TPM fetches plugins

# 2. Launch Neovim (LazyVim auto-installs plugins on first open)
nvim

# 3. Authenticate services
gh auth login                    # GitHub CLI
doppler login                   # Doppler (if you use it)

# 4. Set your terminal emulator font to "MesloLGS NF" for Powerlevel10k icons
```

## Example: brand-new AWS EC2 instance

```
you@local $ ssh -i key.pem ubuntu@<ec2-ip>

ubuntu@ec2 $ sudo apt-get update && sudo apt-get install -y git
ubuntu@ec2 $ git clone https://github.com/perichoncs/dotfiles.git ~/dotfiles
ubuntu@ec2 $ cd ~/dotfiles && bash bootstrap.sh

# ── bootstrap runs (~2-3 min) ──
# [INFO]  Checking prerequisites (git, curl)...
# [OK]    git and curl are available
# [INFO]  Detected package manager: apt
# [INFO]  Installing tmux...
# [INFO]  Installing Neovim (stable from GitHub releases)...
# ...
# [OK]    All programs processed
# [OK]    Dotfiles linked
# [OK]    TPM installed
#
# [INFO]  Bootstrap complete!
# [INFO]  Next steps:
# [INFO]    1. Open tmux and press Ctrl-Space + I to install tmux plugins
# [INFO]    2. Open nvim — LazyVim will auto-install plugins on first launch
# [INFO]    3. Run 'gh auth login' to authenticate GitHub CLI
# [INFO]    4. Run 'doppler login' to authenticate Doppler
# [INFO]    5. Set your terminal font to 'MesloLGS NF' for Powerlevel10k icons
# [INFO]    6. Start a new zsh session to activate Powerlevel10k

ubuntu@ec2 $ tmux            # then Ctrl-Space + I to install plugins
ubuntu@ec2 $ nvim             # LazyVim sets itself up automatically
```

After those steps you have the full environment ready: zsh with Powerlevel10k, tmux with custom keybindings, Neovim with LazyVim, and all CLI tools available.

## Supported package managers

The bootstrap script auto-detects and works with:

- **apt** (Ubuntu / Debian) — including AWS EC2 Ubuntu AMIs
- **dnf** (Fedora / RHEL)
- **pacman** (Arch Linux)

## Repository structure

```
dotfiles/
├── bootstrap.sh             # automated setup script
├── programs-installed.md    # list of programs to install
├── keybindings.md           # full keybinding reference
├── zsh/
│   ├── .zshrc               # zsh config (stowed to ~/.zshrc)
│   └── .p10k.zsh            # Powerlevel10k config (stowed to ~/.p10k.zsh)
├── tmux/
│   └── .tmux.conf           # tmux config (stowed to ~/.tmux.conf)
└── nvim/
    └── .config/nvim/        # Neovim/LazyVim config (stowed to ~/.config/nvim/)
```

## Managing dotfiles day-to-day

```bash
# Re-link after editing configs
cd ~/dotfiles && stow -R tmux nvim zsh

# Add a new stow package (e.g., bash)
mkdir -p ~/dotfiles/bash
mv ~/.bashrc ~/dotfiles/bash/.bashrc
cd ~/dotfiles && stow bash

# Preview what stow would do (dry-run)
stow -n tmux
```

## References

- [keybindings.md](keybindings.md) — full keybinding reference (Cosmic DE, tmux, LazyVim)
- [programs-installed.md](programs-installed.md) — programs installed by the bootstrap script
