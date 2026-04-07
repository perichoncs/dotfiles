#!/usr/bin/env bash
# bootstrap.sh — Set up a fresh machine from the dotfiles repo.
#
# Usage (from a fresh machine):
#   curl -fsSL https://raw.githubusercontent.com/YOUR_USER/dotfiles/main/bootstrap.sh | bash
#
# Or clone first, then run:
#   git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && bash bootstrap.sh
#

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/perichoncs/dotfiles.git}"

# ── Helpers ───────────────────────────────────────────────────
info() { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok() { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
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

command_exists git || install_prerequisites
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

# ── Map program names to install commands per manager ─────────
# Some tools have different package names or need special install methods.
install_pkg() {
  local name="$1"
  case "$name" in
  nvim | neovim)
    install_build_essentials
    install_neovim
    ;;
  gh)
    install_gh
    ;;
  doppler)
    install_doppler
    ;;
  zoxide)
    install_zoxide
    ;;
  fd)
    install_fd
    ;;
  ripgrep | rg)
    pkg_install ripgrep
    ;;
  stow)
    pkg_install stow
    ;;
  tmux)
    pkg_install tmux
    ;;
  jq)
    pkg_install jq
    ;;
  glow)
    install_glow
    ;;
  eza)
    install_eza
    ;;
  zsh)
    install_zsh
    ;;
  xclip)
    pkg_install xclip
    ;;
  ruff)
    install_ruff
    ;;
  lazygit)
    install_lazygit
    ;;
  bat)
    install_bat
    ;;
  fzf)
    install_fzf
    ;;
  go)
    install_go
    ;;
  rust)
    install_rust
    ;;
  python3)
    install_python3
    ;;
  *)
    pkg_install "$name"
    ;;
  esac
}

# Generic package install
pkg_install() {
  local pkg="$1"
  info "Installing $pkg..."
  case "$PKG_MGR" in
  apt) sudo apt-get install -y -qq "$pkg" ;;
  dnf) sudo dnf install -y "$pkg" ;;
  pacman) sudo pacman -S --noconfirm "$pkg" ;;
  esac
}

# ── Special installers ────────────────────────────────────────

install_build_essentials() {
  if command_exists cc && command_exists make; then
    ok "C compiler and make already installed"
    return
  fi
  info "Installing C compiler (needed by Neovim Treesitter)..."
  case "$PKG_MGR" in
  apt) sudo apt-get install -y -qq build-essential ;;
  dnf) sudo dnf groupinstall -y "Development Tools" ;;
  pacman) sudo pacman -S --noconfirm base-devel ;;
  esac
  ok "C compiler installed"
}

install_neovim() {
  if command_exists nvim; then
    ok "nvim already installed"
    return
  fi
  info "Installing Neovim (stable from GitHub releases)..."
  curl -fsSLo /tmp/nvim-linux-x86_64.tar.gz \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  sudo tar -C /usr/local --strip-components=1 -xzf /tmp/nvim-linux-x86_64.tar.gz
  rm -f /tmp/nvim-linux-x86_64.tar.gz
  ok "Neovim installed"
}

install_gh() {
  if command_exists gh; then
    ok "gh already installed"
    return
  fi
  info "Installing GitHub CLI..."
  case "$PKG_MGR" in
  apt)
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
      sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
      sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq gh
    ;;
  dnf) sudo dnf install -y gh ;;
  pacman) sudo pacman -S --noconfirm github-cli ;;
  esac
  ok "gh installed"
}

install_doppler() {
  if command_exists doppler; then
    ok "doppler already installed"
    return
  fi
  info "Installing Doppler CLI..."
  curl -fsSL https://cli.doppler.com/install.sh | sudo bash
  ok "Doppler installed"
}

install_zoxide() {
  if command_exists zoxide; then
    ok "zoxide already installed"
    return
  fi
  info "Installing zoxide..."
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  ok "zoxide installed"
}

install_fd() {
  if command_exists fd || command_exists fdfind; then
    ok "fd already installed"
    return
  fi
  info "Installing fd-find..."
  case "$PKG_MGR" in
  apt) sudo apt-get install -y -qq fd-find ;;
  dnf) sudo dnf install -y fd-find ;;
  pacman) sudo pacman -S --noconfirm fd ;;
  esac
  # On Debian/Ubuntu the binary is "fdfind", create a symlink
  if command_exists fdfind && ! command_exists fd; then
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  fi
  ok "fd installed"
}

install_glow() {
  if command_exists glow; then
    ok "glow already installed"
    return
  fi
  info "Installing glow..."
  case "$PKG_MGR" in
  apt)
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key |
      sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
      sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq glow
    ;;
  dnf) sudo dnf install -y glow ;;
  pacman) sudo pacman -S --noconfirm glow ;;
  esac
  ok "glow installed"
}

install_zsh() {
  if command_exists zsh; then
    ok "zsh already installed"
  else
    info "Installing zsh..."
    pkg_install zsh
    ok "zsh installed"
  fi

  # Install Oh My Zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ok "Oh My Zsh installed"
  else
    ok "Oh My Zsh already installed"
  fi

  # Install Powerlevel10k theme
  local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ ! -d "$p10k_dir" ]]; then
    info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    ok "Powerlevel10k installed"
  else
    ok "Powerlevel10k already installed"
  fi

  # Install zsh-autosuggestions
  local autosugg_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  if [[ ! -d "$autosugg_dir" ]]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$autosugg_dir"
    ok "zsh-autosuggestions installed"
  else
    ok "zsh-autosuggestions already installed"
  fi

  # Install zsh-syntax-highlighting
  local synhl_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  if [[ ! -d "$synhl_dir" ]]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$synhl_dir"
    ok "zsh-syntax-highlighting installed"
  else
    ok "zsh-syntax-highlighting already installed"
  fi

  # Install MesloLGS Nerd Font (recommended for Powerlevel10k)
  install_meslo_nerd_font
}

install_meslo_nerd_font() {
  local font_dir="$HOME/.local/share/fonts"
  if fc-list 2>/dev/null | grep -qi "MesloLGS Nerd Font"; then
    ok "MesloLGS Nerd Font already installed"
    return
  fi
  info "Installing MesloLGS Nerd Font (Powerlevel10k recommended font)..."
  mkdir -p "$font_dir"
  local base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
  curl -fsSLo "$font_dir/MesloLGS NF Regular.ttf"     "$base_url/MesloLGS%20NF%20Regular.ttf"
  curl -fsSLo "$font_dir/MesloLGS NF Bold.ttf"        "$base_url/MesloLGS%20NF%20Bold.ttf"
  curl -fsSLo "$font_dir/MesloLGS NF Italic.ttf"      "$base_url/MesloLGS%20NF%20Italic.ttf"
  curl -fsSLo "$font_dir/MesloLGS NF Bold Italic.ttf" "$base_url/MesloLGS%20NF%20Bold%20Italic.ttf"
  if command_exists fc-cache; then
    fc-cache -f "$font_dir"
  fi
  ok "MesloLGS Nerd Font installed"
}

install_eza() {
  if command_exists eza; then
    ok "eza already installed"
    return
  fi
  info "Installing eza..."
  case "$PKG_MGR" in
  apt)
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc |
      sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" |
      sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq eza
    ;;
  dnf) sudo dnf install -y eza ;;
  pacman) sudo pacman -S --noconfirm eza ;;
  esac
  ok "eza installed"
}

install_ruff() {
  if command_exists ruff; then
    ok "ruff already installed"
    return
  fi
  info "Installing ruff (Python linter/formatter)..."
  if command_exists pip3; then
    pip3 install --user ruff
  elif command_exists pip; then
    pip install --user ruff
  else
    warn "pip not found — installing python3-pip first"
    pkg_install python3-pip
    pip3 install --user ruff
  fi
  ok "ruff installed"
}

install_lazygit() {
  if command_exists lazygit; then
    ok "lazygit already installed"
    return
  fi
  info "Installing lazygit..."
  local version
  version=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -fsSLo /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
  tar -C /tmp -xzf /tmp/lazygit.tar.gz lazygit
  sudo install /tmp/lazygit /usr/local/bin/lazygit
  rm -f /tmp/lazygit /tmp/lazygit.tar.gz
  ok "lazygit installed"
}

install_bat() {
  if command_exists bat || command_exists batcat; then
    ok "bat already installed"
    return
  fi
  info "Installing bat..."
  case "$PKG_MGR" in
  apt) sudo apt-get install -y -qq bat ;;
  dnf) sudo dnf install -y bat ;;
  pacman) sudo pacman -S --noconfirm bat ;;
  esac
  # On Debian/Ubuntu the binary is "batcat", create a symlink
  if command_exists batcat && ! command_exists bat; then
    sudo ln -sf "$(which batcat)" /usr/local/bin/bat
  fi
  ok "bat installed"
}

install_fzf() {
  if command_exists fzf; then
    ok "fzf already installed"
    return
  fi
  info "Installing fzf..."
  case "$PKG_MGR" in
  apt) sudo apt-get install -y -qq fzf ;;
  dnf) sudo dnf install -y fzf ;;
  pacman) sudo pacman -S --noconfirm fzf ;;
  esac
  ok "fzf installed"
}

install_go() {
  if command_exists go; then
    ok "Go already installed"
    return
  fi
  info "Installing Go (latest stable)..."
  local go_version
  go_version=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)
  curl -fsSLo /tmp/go.tar.gz "https://go.dev/dl/${go_version}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm -f /tmp/go.tar.gz
  ok "Go ${go_version} installed to /usr/local/go"
}

install_rust() {
  if command_exists rustc; then
    ok "Rust already installed"
    return
  fi
  info "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
  # Source cargo env for the rest of this script
  # shellcheck disable=SC1091
  [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
  ok "Rust installed (rustc, cargo, rustup)"
}

install_python3() {
  if command_exists python3; then
    ok "python3 already installed"
    return
  fi
  info "Installing python3..."
  case "$PKG_MGR" in
  apt) sudo apt-get install -y -qq python3 python3-pip python3-venv ;;
  dnf) sudo dnf install -y python3 python3-pip ;;
  pacman) sudo pacman -S --noconfirm python python-pip ;;
  esac
  ok "python3 installed"
}

# ── Parse programs-installed.md ───────────────────────────────
install_programs() {
  local programs_file="$DOTFILES_DIR/programs-installed.md"
  if [[ ! -f "$programs_file" ]]; then
    warn "programs-installed.md not found, skipping package install"
    return
  fi

  info "Reading programs from programs-installed.md..."

  while IFS= read -r line; do
    # Skip headings, blank lines, and comments
    line="$(echo "$line" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')"
    [[ -z "$line" ]] && continue
    [[ "$line" == "#"* ]] && continue
    [[ "$line" == "---"* ]] && continue

    install_pkg "$line"
  done <"$programs_file"

  ok "All programs processed"
}

# ── Install GNU Stow (needed for symlinking) ─────────────────
info "Ensuring GNU Stow is installed..."
if ! command_exists stow; then
  pkg_install stow
fi
ok "stow is available"

# ── Install programs ──────────────────────────────────────────
install_programs

# ── Stow dotfiles packages ───────────────────────────────────
info "Linking dotfiles with stow..."
cd "$DOTFILES_DIR"

# Remove existing targets if they're real files/dirs (not symlinks)
[[ -f "$HOME/.tmux.conf" && ! -L "$HOME/.tmux.conf" ]] && mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
[[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
[[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
[[ -f "$HOME/.p10k.zsh" && ! -L "$HOME/.p10k.zsh" ]] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"

mkdir -p "$HOME/.config"
stow tmux
stow nvim
stow zsh
ok "Dotfiles linked"

# ── Install tmux plugin manager (TPM) ────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  info "Installing tmux plugin manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM installed — open tmux and press prefix+I to install plugins"
else
  ok "TPM already installed"
fi

# ── Set zsh as default shell ─────────────────────────────────
if command_exists zsh; then
  current_shell="$(basename "$SHELL")"
  if [[ "$current_shell" != "zsh" ]]; then
    info "Setting zsh as default shell..."
    zsh_path="$(which zsh)"
    if grep -qF "$zsh_path" /etc/shells; then
      chsh -s "$zsh_path" || warn "Could not change default shell — run: chsh -s $zsh_path"
    else
      warn "zsh not in /etc/shells — run: sudo sh -c 'echo $zsh_path >> /etc/shells' && chsh -s $zsh_path"
    fi
  else
    ok "zsh is already the default shell"
  fi
fi

# ── Post-install summary ─────────────────────────────────────
echo ""
info "══════════════════════════════════════════════════"
info "  Bootstrap complete!"
info "══════════════════════════════════════════════════"
echo ""
info "Next steps:"
info "  1. Open tmux and press Ctrl-Space + I to install tmux plugins"
info "  2. Open nvim — LazyVim will auto-install plugins on first launch"
info "  3. Run 'gh auth login' to authenticate GitHub CLI"
info "  4. Run 'doppler login' to authenticate Doppler"
info "  5. Set your terminal font to 'MesloLGS NF' for Powerlevel10k icons"
info "  6. Start a new zsh session to activate Powerlevel10k"
echo ""
