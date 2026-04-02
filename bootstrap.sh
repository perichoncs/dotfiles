#!/usr/bin/env bash
# bootstrap.sh — Set up a fresh machine from the dotfiles repo.
#
# Usage (from a fresh machine):
#   curl -fsSL https://raw.githubusercontent.com/YOUR_USER/dotfiles/main/bootstrap.sh | bash
#
# Or clone first, then run:
#   git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && bash bootstrap.sh

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/YOUR_USER/dotfiles.git}"

# ── Helpers ───────────────────────────────────────────────────
info()  { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
fail()  { printf "\033[1;31m[FAIL]\033[0m  %s\n" "$1"; exit 1; }

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

# ── Map program names to install commands per manager ─────────
# Some tools have different package names or need special install methods.
install_pkg() {
    local name="$1"
    case "$name" in
        nvim|neovim)
            install_neovim ;;
        gh)
            install_gh ;;
        doppler)
            install_doppler ;;
        zoxide)
            install_zoxide ;;
        fd)
            install_fd ;;
        ripgrep|rg)
            pkg_install ripgrep ;;
        stow)
            pkg_install stow ;;
        tmux)
            pkg_install tmux ;;
        jq)
            pkg_install jq ;;
        glow)
            install_glow ;;
        eza)
            install_eza ;;
        xclip)
            pkg_install xclip ;;
        *)
            pkg_install "$name" ;;
    esac
}

# Generic package install
pkg_install() {
    local pkg="$1"
    info "Installing $pkg..."
    case "$PKG_MGR" in
        apt)    sudo apt-get install -y -qq "$pkg" ;;
        dnf)    sudo dnf install -y "$pkg" ;;
        pacman) sudo pacman -S --noconfirm "$pkg" ;;
    esac
}

# ── Special installers ────────────────────────────────────────

install_neovim() {
    if command_exists nvim; then ok "nvim already installed"; return; fi
    info "Installing Neovim (stable from GitHub releases)..."
    curl -fsSLo /tmp/nvim-linux-x86_64.tar.gz \
        "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    sudo tar -C /usr/local --strip-components=1 -xzf /tmp/nvim-linux-x86_64.tar.gz
    rm -f /tmp/nvim-linux-x86_64.tar.gz
    ok "Neovim installed"
}

install_gh() {
    if command_exists gh; then ok "gh already installed"; return; fi
    info "Installing GitHub CLI..."
    case "$PKG_MGR" in
        apt)
            sudo mkdir -p -m 755 /etc/apt/keyrings
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
                | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
            sudo apt-get update -qq && sudo apt-get install -y -qq gh
            ;;
        dnf) sudo dnf install -y gh ;;
        pacman) sudo pacman -S --noconfirm github-cli ;;
    esac
    ok "gh installed"
}

install_doppler() {
    if command_exists doppler; then ok "doppler already installed"; return; fi
    info "Installing Doppler CLI..."
    curl -fsSL https://cli.doppler.com/install.sh | sudo bash
    ok "Doppler installed"
}

install_zoxide() {
    if command_exists zoxide; then ok "zoxide already installed"; return; fi
    info "Installing zoxide..."
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    ok "zoxide installed"
}

install_fd() {
    if command_exists fd || command_exists fdfind; then ok "fd already installed"; return; fi
    info "Installing fd-find..."
    case "$PKG_MGR" in
        apt)    sudo apt-get install -y -qq fd-find ;;
        dnf)    sudo dnf install -y fd-find ;;
        pacman) sudo pacman -S --noconfirm fd ;;
    esac
    # On Debian/Ubuntu the binary is "fdfind", create a symlink
    if command_exists fdfind && ! command_exists fd; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi
    ok "fd installed"
}

install_glow() {
    if command_exists glow; then ok "glow already installed"; return; fi
    info "Installing glow..."
    case "$PKG_MGR" in
        apt)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key \
                | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
                | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
            sudo apt-get update -qq && sudo apt-get install -y -qq glow
            ;;
        dnf) sudo dnf install -y glow ;;
        pacman) sudo pacman -S --noconfirm glow ;;
    esac
    ok "glow installed"
}

install_eza() {
    if command_exists eza; then ok "eza already installed"; return; fi
    info "Installing eza..."
    case "$PKG_MGR" in
        apt)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
                | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
                | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
            sudo apt-get update -qq && sudo apt-get install -y -qq eza
            ;;
        dnf) sudo dnf install -y eza ;;
        pacman) sudo pacman -S --noconfirm eza ;;
    esac
    ok "eza installed"
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
    done < "$programs_file"

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

mkdir -p "$HOME/.config"
stow tmux
stow nvim
ok "Dotfiles linked"

# ── Install tmux plugin manager (TPM) ────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    info "Installing tmux plugin manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed — open tmux and press prefix+I to install plugins"
else
    ok "TPM already installed"
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
info "  5. Add to ~/.bashrc or ~/.zshrc:"
info "       eval \"\$(zoxide init bash)\"   # or zsh"
echo ""
