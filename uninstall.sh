#!/usr/bin/env bash
# uninstall.sh — Remove dotfiles symlinks and optionally installed programs.
#
# Usage:
#   bash uninstall.sh              # remove symlinks and configs only
#   bash uninstall.sh --full       # also remove installed programs
#
# After running this, you can do a fresh install with:
#   cd ~/dotfiles && bash bootstrap.sh

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
FULL_UNINSTALL=false

[[ "${1:-}" == "--full" ]] && FULL_UNINSTALL=true

# ── Helpers ───────────────────────────────────────────────────
info() { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok() { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn() { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
fail() {
  printf "\033[1;31m[FAIL]\033[0m  %s\n" "$1"
  exit 1
}
command_exists() { command -v "$1" &>/dev/null; }

# ── Remove stow symlinks ─────────────────────────────────────
remove_symlinks() {
  info "Removing dotfile symlinks..."
  cd "$DOTFILES_DIR" 2>/dev/null || {
    warn "Dotfiles dir not found at $DOTFILES_DIR, skipping stow"
    return
  }

  for pkg in tmux nvim zsh; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
      stow -D "$pkg" 2>/dev/null && ok "Unlinked $pkg" || warn "Could not unlink $pkg"
    fi
  done
}

# ── Remove TPM (tmux plugin manager) ─────────────────────────
remove_tpm() {
  if [[ -d "$HOME/.tmux/plugins" ]]; then
    info "Removing tmux plugins and TPM..."
    rm -rf "$HOME/.tmux/plugins"
    ok "tmux plugins removed"
  fi
}

# ── Remove Neovim data (lazy.nvim plugins, Mason, caches) ────
remove_nvim_data() {
  info "Removing Neovim plugin data and caches..."
  local nvim_data="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
  local nvim_state="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
  local nvim_cache="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

  [[ -d "$nvim_data" ]] && rm -rf "$nvim_data" && ok "Removed $nvim_data"
  [[ -d "$nvim_state" ]] && rm -rf "$nvim_state" && ok "Removed $nvim_state"
  [[ -d "$nvim_cache" ]] && rm -rf "$nvim_cache" && ok "Removed $nvim_cache"
}

# ── Remove Oh My Zsh and plugins ─────────────────────────────
remove_ohmyzsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    info "Removing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
    ok "Oh My Zsh removed"
  fi
}

# ── Restore backed-up configs ────────────────────────────────
restore_backups() {
  info "Restoring any backed-up configs..."
  for f in "$HOME/.tmux.conf.bak" "$HOME/.zshrc.bak" "$HOME/.p10k.zsh.bak"; do
    if [[ -f "$f" ]]; then
      mv "$f" "${f%.bak}"
      ok "Restored ${f%.bak}"
    fi
  done
  if [[ -d "$HOME/.config/nvim.bak" ]]; then
    mv "$HOME/.config/nvim.bak" "$HOME/.config/nvim"
    ok "Restored ~/.config/nvim"
  fi
}

# ── Remove installed programs (only with --full) ─────────────
remove_programs() {
  if [[ "$FULL_UNINSTALL" != true ]]; then
    return
  fi

  info "Full uninstall: removing installed programs..."

  # Detect package manager
  local PKG_MGR=""
  if command_exists apt-get; then
    PKG_MGR="apt"
  elif command_exists dnf; then
    PKG_MGR="dnf"
  elif command_exists pacman; then
    PKG_MGR="pacman"
  fi

  # Remove packages installed via package manager
  local pkgs_to_remove=(tmux ripgrep stow jq xclip fzf)
  for pkg in "${pkgs_to_remove[@]}"; do
    if command_exists "$pkg" || command_exists "${pkg}find" 2>/dev/null; then
      info "Removing $pkg..."
      case "$PKG_MGR" in
      apt) sudo apt-get remove -y -qq "$pkg" 2>/dev/null || true ;;
      dnf) sudo dnf remove -y "$pkg" 2>/dev/null || true ;;
      pacman) sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null || true ;;
      esac
    fi
  done

  # Remove bat (named differently on Debian)
  if command_exists bat || command_exists batcat; then
    info "Removing bat..."
    case "$PKG_MGR" in
    apt) sudo apt-get remove -y -qq bat 2>/dev/null || true ;;
    dnf) sudo dnf remove -y bat 2>/dev/null || true ;;
    pacman) sudo pacman -Rns --noconfirm bat 2>/dev/null || true ;;
    esac
    sudo rm -f /usr/local/bin/bat
  fi

  # Remove fd (named differently on Debian)
  if command_exists fd || command_exists fdfind; then
    info "Removing fd..."
    case "$PKG_MGR" in
    apt) sudo apt-get remove -y -qq fd-find 2>/dev/null || true ;;
    dnf) sudo dnf remove -y fd-find 2>/dev/null || true ;;
    pacman) sudo pacman -Rns --noconfirm fd 2>/dev/null || true ;;
    esac
    sudo rm -f /usr/local/bin/fd
  fi

  # Remove Neovim (installed from tarball to /usr/local)
  if command_exists nvim; then
    info "Removing Neovim..."
    sudo rm -f /usr/local/bin/nvim
    sudo rm -rf /usr/local/lib/nvim /usr/local/share/nvim
  fi

  # Remove lazygit
  if command_exists lazygit; then
    info "Removing lazygit..."
    sudo rm -f /usr/local/bin/lazygit
  fi

  # Remove Go
  if [[ -d /usr/local/go ]]; then
    info "Removing Go..."
    sudo rm -rf /usr/local/go
  fi

  # Remove Rust (rustup self uninstall)
  if command_exists rustup; then
    info "Removing Rust..."
    rustup self uninstall -y 2>/dev/null || true
  fi

  # Remove ruff
  if command_exists ruff; then
    info "Removing ruff..."
    pip3 uninstall -y ruff 2>/dev/null || pip uninstall -y ruff 2>/dev/null || true
  fi

  # Remove zoxide
  if command_exists zoxide; then
    info "Removing zoxide..."
    rm -f "$HOME/.local/bin/zoxide"
  fi

  # Remove eza (added via third-party repo)
  if command_exists eza; then
    info "Removing eza..."
    case "$PKG_MGR" in
    apt) sudo apt-get remove -y -qq eza 2>/dev/null || true ;;
    dnf) sudo dnf remove -y eza 2>/dev/null || true ;;
    pacman) sudo pacman -Rns --noconfirm eza 2>/dev/null || true ;;
    esac
  fi

  # Remove MesloLGS Nerd Font
  local font_dir="$HOME/.local/share/fonts"
  if ls "$font_dir"/MesloLGS* &>/dev/null; then
    info "Removing MesloLGS Nerd Font..."
    rm -f "$font_dir"/MesloLGS*
    command_exists fc-cache && fc-cache -f "$font_dir"
  fi

  ok "Programs removed"
}

# ── Main ──────────────────────────────────────────────────────
echo ""
info "══════════════════════════════════════════════════"
if [[ "$FULL_UNINSTALL" == true ]]; then
  info "  Dotfiles FULL uninstall"
else
  info "  Dotfiles uninstall (symlinks & configs only)"
fi
info "══════════════════════════════════════════════════"
echo ""

remove_symlinks
remove_tpm
remove_nvim_data
remove_ohmyzsh
restore_backups
remove_programs

echo ""
info "══════════════════════════════════════════════════"
info "  Uninstall complete!"
info "══════════════════════════════════════════════════"
echo ""
info "To do a fresh install, run:"
info "  cd ~/dotfiles && bash bootstrap.sh"
echo ""
if [[ "$FULL_UNINSTALL" != true ]]; then
  info "Tip: use 'bash uninstall.sh --full' to also remove installed programs."
fi
