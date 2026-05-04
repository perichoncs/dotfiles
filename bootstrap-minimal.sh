#!/usr/bin/env bash
# bootstrap-minimal.sh — Set up a minimal machine from the dotfiles repo.
# Tools: git, stow, nvim, tmux, ripgrep, fzf
#
# Usage (from a fresh machine):
#   curl -fsSL https://raw.githubusercontent.com/perichoncs/dotfiles/main/bootstrap-minimal.sh | bash
#
# Or clone first, then run:
#   git clone https://github.com/perichoncs/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && bash bootstrap-minimal.sh

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/perichoncs/dotfiles.git}"

# ── Helpers ───────────────────────────────────────────────────
info() { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok()   { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn() { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
fail() {
  printf "\033[1;31m[FAIL]\033[0m  %s\n" "$1"
  exit 1
}

command_exists() { command -v "$1" &>/dev/null; }

# ── Pre-flight: ensure we have git + curl ─────────────────────
install_prerequisites() {
  info "Checking prerequisites (git, curl)..."
  if command_exists apt-get; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq git curl
  elif command_exists dnf; then
    sudo dnf install -y git curl
  elif command_exists pacman; then
    sudo pacman -Sy --noconfirm git curl
  else
    fail "Unsupported package manager. Install git and curl manually."
  fi
  ok "git and curl are available"
}

command_exists git  || install_prerequisites
command_exists curl || install_prerequisites

# ── Clone dotfiles if not already present ─────────────────────
if [[ ! -d "$DOTFILES_DIR" ]]; then
  info "Cloning dotfiles into $DOTFILES_DIR..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  ok "Dotfiles cloned"
else
  info "Dotfiles already present at $DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# ── Detect package manager ────────────────────────────────────
if command_exists apt-get; then
  PKG_MGR="apt"
elif command_exists dnf; then
  PKG_MGR="dnf"
elif command_exists pacman; then
  PKG_MGR="pacman"
else
  fail "No supported package manager found (apt/dnf/pacman)"
fi

info "Detected package manager: $PKG_MGR"

# ── Generic package install ───────────────────────────────────
pkg_install() {
  local pkg="$1"
  info "Installing $pkg..."
  case "$PKG_MGR" in
  apt)    sudo apt-get install -y -qq "$pkg" ;;
  dnf)    sudo dnf install -y "$pkg" ;;
  pacman) sudo pacman -S --noconfirm "$pkg" ;;
  esac
}

# ── Installers ────────────────────────────────────────────────

install_build_essentials() {
  if command_exists cc && command_exists make; then
    ok "C compiler and make already installed"
    return
  fi
  info "Installing build essentials (needed by Neovim Treesitter)..."
  case "$PKG_MGR" in
  apt)    sudo apt-get install -y -qq build-essential ;;
  dnf)    sudo dnf groupinstall -y "Development Tools" ;;
  pacman) sudo pacman -S --noconfirm base-devel ;;
  esac
  ok "Build essentials installed"
}

install_neovim() {
  if command_exists nvim; then
    ok "nvim already installed"
    return
  fi
  install_build_essentials
  info "Installing Neovim (stable from GitHub releases)..."
  curl -fsSLo /tmp/nvim-linux-x86_64.tar.gz \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  sudo tar -C /usr/local --strip-components=1 -xzf /tmp/nvim-linux-x86_64.tar.gz
  rm -f /tmp/nvim-linux-x86_64.tar.gz
  ok "Neovim installed"
}

install_ripgrep() {
  if command_exists rg; then
    ok "ripgrep already installed"
    return
  fi
  pkg_install ripgrep
}

install_fzf() {
  if command_exists fzf; then
    ok "fzf already installed"
    return
  fi
  pkg_install fzf
}

install_tmux() {
  if command_exists tmux; then
    ok "tmux already installed"
    return
  fi
  pkg_install tmux
}

install_stow() {
  if command_exists stow; then
    ok "stow already installed"
    return
  fi
  pkg_install stow
}

# ── Install tools ─────────────────────────────────────────────
info "Installing tools..."
install_stow
install_tmux
install_ripgrep
install_fzf
install_neovim
ok "All tools installed"

# ── Stow dotfiles ─────────────────────────────────────────────
info "Linking dotfiles with stow..."
cd "$DOTFILES_DIR"

mkdir -p "$HOME/.config"

# Back up any existing real files before stowing
[[ -f "$HOME/.tmux.conf" && ! -L "$HOME/.tmux.conf" ]] && mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
[[ -d "$HOME/.config/nvim"  && ! -L "$HOME/.config/nvim"  ]] && mv "$HOME/.config/nvim"  "$HOME/.config/nvim.bak"
[[ -f "$HOME/.bashrc"       && ! -L "$HOME/.bashrc"       ]] && mv "$HOME/.bashrc" "$HOME/.bashrc.bak"

stow tmux
stow nvim
stow bash
ok "Dotfiles linked"

# ── Install tmux plugin manager (TPM) ────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  info "Installing tmux plugin manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM installed — open tmux and press prefix+I to install plugins"
else
  ok "TPM already installed"
fi

# ── Post-install summary ──────────────────────────────────────
echo ""
info "══════════════════════════════════════════════════"
info "  Minimal bootstrap complete!"
info "══════════════════════════════════════════════════"
echo ""
info "Installed: git, stow, nvim, tmux, ripgrep (rg), fzf"
echo ""
info "Next steps:"
info "  1. Reload bash config:  source ~/.bashrc"
info "  2. Open tmux and press Ctrl-Space + I to install tmux plugins"
info "  3. Open nvim — LazyVim will auto-install plugins on first launch"
echo ""
