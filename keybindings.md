# Keybindings Reference

Environment: **Cosmic DE** + **tmux** (prefix: `Ctrl-Space`) + **LazyVim** (leader: `Space`)

---

## Cosmic Desktop (Super key)

| Keybinding | Action |
|---|---|
| Super | Open app launcher |
| Super + Q | Close window |
| Super + M | Maximize/restore window |
| Super + h | Tile window to left half |
| Super + j | Tile window to bottom half |
| Super + k | Tile window to top half |
| Super + l | Tile window to right half |
| Super + 1-9 | Switch to workspace |
| Super + Shift + 1-9 | Move window to workspace |
| Super + T | Open terminal |
| Super + Tab | App switcher |

> **Note:** By default, Cosmic uses `Super + h/j/k/l` (and arrow keys) to **switch between windows**. These are rebound here for **tiling** (snapping windows to screen halves). Configure in Cosmic Settings → Keyboard → Shortcuts → Tiling.
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

### Copy Mode (vi-style) — copies to system clipboard via xclip

| Keybinding | Action |
|---|---|
| Ctrl-Space, [ | Enter copy mode |
| v (in copy mode) | Begin visual selection |
| V (in copy mode) | Begin line selection |
| y (in copy mode) | Yank selection → system clipboard, exit copy mode |
| q (in copy mode) | Exit copy mode without copying |
| / (in copy mode) | Search forward |
| ? (in copy mode) | Search backward |

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

### Go Tooling (Space c g — only in Go files)

| Keybinding | Command | Action |
|---|---|---|
| Space c g s | :GoFillStruct | Fill struct fields with zero values |
| Space c g e | :GoIfErr | Generate `if err != nil` block |
| Space c g a | :GoAddTag | Add struct tags (json by default) |
| Space c g r | :GoRmTag | Remove struct tags |
| Space c g i | :GoImpl | Generate interface implementation stubs |
| Space c g f | :GoTestFunc | Run test under cursor |
| Space c g p | :GoTest | Run tests for entire package |

> **Mnemonic:** `c` = code, `g` = go, then: `s`truct, `e`rr, `a`dd tag, `r`emove tag, `i`mpl, `f`unc test, `p`ackage test.

### Debugging (Space d — via nvim-dap + delve)

| Keybinding | Action |
|---|---|
| Space d b | Toggle breakpoint on current line |
| Space d B | Set conditional breakpoint (prompts for expression) |
| Space d c | Start / Continue execution |
| Space d C | Run to cursor |
| Space d i | Step into function |
| Space d o | Step out of function |
| Space d O | Step over (next line) |
| Space d P | Pause execution |
| Space d t | Terminate debug session |
| Space d r | Toggle REPL |
| Space d u | Toggle DAP UI (variables, stack, breakpoints) |
| Space d e | Evaluate expression under cursor |
| Space d l | Re-run last debug session |
| Space d a | Run with arguments (prompts for args) |
| Space d w | Show debug widgets |

> **Quick start:** Place cursor on a Go `func Test...`, press `Space d b` to set a breakpoint,
> then `Space d c` to start debugging. Use `Space d i/o/O` to step through code.
> `Space d u` opens the full DAP UI with variable inspection.

### Testing (Space t — via neotest)

| Keybinding | Action |
|---|---|
| Space t r | Run nearest test |
| Space t t | Run all tests in file |
| Space t T | Run all test files in project |
| Space t l | Re-run last test |
| Space t d | Debug nearest test (launches DAP) |
| Space t o | Show test output |
| Space t O | Toggle output panel |
| Space t s | Toggle test summary sidebar |
| Space t S | Stop running tests |

### Copy & Paste — system clipboard (LazyVim sets clipboard=unnamedplus)

| Keybinding | Action |
|---|---|
| y | Yank (copy) motion/selection → system clipboard |
| yy | Yank entire line → system clipboard |
| p | Paste after cursor (from system clipboard) |
| P | Paste before cursor (from system clipboard) |
| Visual + y | Select text then yank → system clipboard |
| "+y | Explicit yank to system clipboard (same effect) |
| Ctrl-Shift-V | Paste from system clipboard (terminal passthrough) |

> **Note:** LazyVim sets `clipboard = "unnamedplus"` by default, so every yank/put
> in Neovim automatically uses the system clipboard. No `"+` prefix needed.

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
┌──────────────────────────────────────────────────────────────┐
│  Cosmic DE      →  Super + ...                               │
│    Tiling       →  Super + h/j/k/l  (custom, replaces arrows)│
│  tmux           →  Ctrl-Space + ...                          │
│  Neovim/LazyVim →  Space + ...                               │
│  Shared         →  Ctrl-h/j/k/l (navigator)                  │
└──────────────────────────────────────────────────────────────┘
```

No layer conflicts with this setup.

---

## Clipboard Integration Summary

Everything is wired to the **system clipboard** — copy in one tool, paste in any other.

| Context | Copy | Paste |
|---|---|---|
| **Neovim** | `y` (yank) | `p` / `P` |
| **tmux copy mode** | `v` to select → `y` to yank | `Ctrl-Shift-V` (terminal) |
| **Terminal** | Select with mouse (if enabled) | `Ctrl-Shift-V` |
| **Any app → Neovim** | `Ctrl-C` / system copy | `p` in Normal, `Ctrl-Shift-V` in Insert |
| **Neovim → Any app** | `y` in Neovim | `Ctrl-V` / system paste |
| **tmux → Any app** | `y` in copy mode | `Ctrl-V` / system paste |

> **How it works:**
> - Neovim: `clipboard = "unnamedplus"` syncs all yanks with the system clipboard.
> - tmux: `y` in copy mode pipes to `xclip -selection clipboard`.
> - Both read/write the same X11 clipboard — full interop.

---

## CLI Tools Reference

These are not keybindings — they are essential commands for the daily workflow.

---

### gh — GitHub CLI

```bash
# Auth
gh auth login                          # authenticate with GitHub
gh auth status                         # check current auth status

# Repos
gh repo create <name> --public         # create a new repo
gh repo clone <user>/<repo>            # clone a repo
gh repo view --web                     # open current repo in browser
gh repo fork <user>/<repo> --clone     # fork and clone

# Pull Requests
gh pr create                           # create PR (interactive)
gh pr list                             # list open PRs
gh pr checkout <number>                # checkout a PR branch
gh pr status                           # PRs involving you
gh pr merge <number> --squash          # merge PR (squash)
gh pr view <number> --web              # open PR in browser

# Issues
gh issue create                        # create an issue (interactive)
gh issue list                          # list open issues
gh issue view <number>                 # view an issue
gh issue close <number>                # close an issue

# Workflows / Actions
gh run list                            # list workflow runs
gh run view <id>                       # view a workflow run
gh run watch                           # watch current run live
gh workflow list                       # list workflows
gh workflow run <name>                 # trigger a workflow manually
```

---

### gh copilot — GitHub Copilot CLI

```bash
gh copilot suggest "how do I..."       # suggest a shell command
gh copilot explain "command here"      # explain what a command does

# Aliases (add to ~/.bashrc or ~/.zshrc for convenience)
alias '??'='gh copilot suggest -t shell'
alias 'git?'='gh copilot suggest -t git'
alias 'gh?'='gh copilot suggest -t gh'
```

---

### ripgrep (rg) — Fast Search

```bash
rg "pattern"                           # search pattern in current dir (recursive)
rg "pattern" src/                      # search in specific directory
rg -i "pattern"                        # case-insensitive search
rg -l "pattern"                        # list only matching filenames
rg -n "pattern"                        # show line numbers
rg -t lua "pattern"                    # search only Lua files
rg -t py -t go "pattern"              # search in multiple file types
rg --hidden "pattern"                  # include hidden files
rg -A 3 -B 3 "pattern"               # show 3 lines after/before match
rg -c "pattern"                        # count matches per file
rg "pattern" --glob "!node_modules"   # exclude a directory
rg -e "foo" -e "bar"                  # match multiple patterns
rg "TODO|FIXME"                        # find all TODOs/FIXMEs
```

---

### zoxide (z) — Smarter cd

```bash
z <dir>                                # jump to a frecency-ranked directory
z foo bar                              # jump to dir matching "foo" and "bar"
zi                                     # interactive directory picker (uses fzf)
z -                                    # go back to previous directory
zoxide query "foo"                     # show best match without jumping
zoxide query --list                    # list all known directories
zoxide remove <path>                   # remove a path from the database
zoxide add <path>                      # manually add a path

# Add to ~/.bashrc / ~/.zshrc (one-time setup)
eval "$(zoxide init bash)"             # bash
eval "$(zoxide init zsh)"              # zsh
```

---

### fd — Fast File Finder (replaces find)

```bash
fd <name>                              # find files matching name (recursive)
fd -e lua                              # find files with .lua extension
fd -e go -e yaml                       # multiple extensions
fd -H <name>                           # include hidden files
fd -I <name>                           # include gitignored files
fd -t f <name>                         # type: files only
fd -t d <name>                         # type: directories only
fd -d 2 <name>                         # max depth 2
fd <name> src/                         # search in specific dir
fd -x echo {}                          # execute command for each result
fd -e yaml --exec bat {}               # preview every yaml file
fd "^test"                             # regex: files starting with "test"
```

---

### jq — JSON Processor

```bash
jq '.'                                 # pretty-print JSON
jq '.key'                              # extract a field
jq '.key.nested'                       # nested field
jq '.array[0]'                         # first array element
jq '.array[]'                          # all array elements
jq '.[] | .name'                       # extract "name" from each item
jq 'length'                            # length of array or object
jq 'keys'                              # list object keys
jq 'select(.active == true)'           # filter: only active items
jq '{name, age}'                       # reshape: keep only name and age
jq '.name | ascii_upcase'             # transform: uppercase
jq -r '.token'                         # raw output (no quotes)
jq -c '.'                              # compact output (one line)
jq --arg x "hello" '{msg: $x}'        # pass shell variable into jq
jq -n '[range(5)]'                     # use without input: generate [0,1,2,3,4]
curl -s https://api.github.com/users/octocat | jq '.login'   # pipe from curl
cat file.json | jq '.items[] | select(.status == "active")'  # filter array
```

---

### Doppler — Secret Management

```bash
# Setup
doppler login                          # authenticate with Doppler
doppler setup                          # link current project to a Doppler config

# Secrets
doppler secrets                        # list all secrets for current config
doppler secrets get SECRET_NAME        # get a specific secret value
doppler secrets set KEY=VALUE          # set a secret
doppler secrets delete KEY             # delete a secret
doppler secrets download --format=env  # download all secrets as .env file

# Run with injected secrets
doppler run -- your-command            # run any command with secrets as env vars
doppler run -- go run main.go          # e.g. run Go app with secrets
doppler run -- docker-compose up       # inject into docker-compose

# Projects / Configs
doppler projects                       # list projects
doppler configs                        # list configs in current project
doppler configure                      # view current project/config binding

# CI / non-interactive
doppler secrets download --no-file --format=json  # output JSON (for scripts)
```

---

### GNU Stow — Dotfiles Symlink Manager

```bash
# From inside ~/dotfiles
stow tmux                              # symlink tmux package (~/.tmux.conf)
stow nvim                              # symlink nvim package (~/.config/nvim)
stow tmux nvim                         # stow multiple packages at once
stow -n tmux                           # dry-run: see what would be linked
stow -D tmux                           # delete (unlink) a package
stow -R tmux                           # restow: unlink then re-link (useful after moves)

# From outside ~/dotfiles, specify target and dir
stow --dir=~/dotfiles --target=~ tmux

# Structure rule (Stow mirrors the path from package root to ~)
# dotfiles/tmux/.tmux.conf           → ~/.tmux.conf
# dotfiles/nvim/.config/nvim/        → ~/.config/nvim/
```

---

## Key Layering Summary

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

```bash
# after cloning on a new machine
git clone git@github.com:YOUR_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow tmux nvim    # creates all symlinks automatically
```