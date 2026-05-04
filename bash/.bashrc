# ~/.bashrc — minimal bash config (managed by dotfiles)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ── History ───────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

# ── Window size ───────────────────────────────────────────────
shopt -s checkwinsize

# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# ── Editor ───────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ── Prompt ───────────────────────────────────────────────────
# Simple git-aware prompt: user@host:dir (branch) $
_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) && echo " ($branch)"
}
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0;33m\]$(_git_branch)\[\e[0m\]\$ '

# ── fzf ──────────────────────────────────────────────────────
# Load fzf key bindings and completion if available
[[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && \
  source /usr/share/doc/fzf/examples/key-bindings.bash
[[ -f /usr/share/bash-completion/completions/fzf ]] && \
  source /usr/share/bash-completion/completions/fzf

# ── Aliases ──────────────────────────────────────────────────
alias ll='ls -lah --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias v='nvim'
alias vi='nvim'
