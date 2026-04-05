-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- ─────────────────────────────────────────────────────────────────────────────
-- ESC — Normal mode
-- Default in LazyVim: clears search highlight and returns to Normal mode.
-- The ESC "switches lines" bug was caused by ttimeoutlen being too high:
-- pressing <Esc> then j/k quickly was interpreted as <A-j>/<A-k> (move line).
-- Fixed via `vim.opt.ttimeoutlen = 0` in options.lua.
-- ─────────────────────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear search highlight" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Disable move-line keybinds (<A-j>/<A-k>) — LazyVim sets these by default.
-- Removed because pressing <Esc> + j/k quickly triggers them by accident,
-- causing lines to jump unexpectedly. Combined with ttimeoutlen=0 in options.lua.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")

-- ─────────────────────────────────────────────────────────────────────────────
-- Indenting — stay in visual mode after indent/dedent
-- ─────────────────────────────────────────────────────────────────────────────
map("v", "<", "<gv", { desc = "Dedent and keep selection" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })

-- ─────────────────────────────────────────────────────────────────────────────
-- LazyVim built-in keybinds (reference — set automatically, not redefined here)
-- ─────────────────────────────────────────────────────────────────────────────

-- Navigation (splits — shared with tmux via vim-tmux-navigator plugin)
--   Ctrl-h          → move to left split
--   Ctrl-j          → move to split below
--   Ctrl-k          → move to split above
--   Ctrl-l          → move to right split

-- File & Search (Telescope)
--   <Space><Space>  → fuzzy find files in project
--   <Space>/        → live grep across project
--   <Space>,        → switch between open buffers
--   <Space>ff       → find files
--   <Space>fr       → recent files
--   <Space>sg       → grep search
--   <Space>ss       → search symbols in buffer

-- Splits / Windows
--   <Space>|        → open vertical split
--   <Space>-        → open horizontal split
--   <Space>wd       → close current split
--   <Space>ww       → switch to next split

-- Buffers
--   [b / ]b         → previous / next buffer
--   <Space>bd       → delete (close) current buffer
--   <Space>bb       → switch buffer via picker

-- Save & Quit
--   <Space>w        → save file
--   <Space>q        → quit current window
--   <Space>Q        → quit all windows

-- LSP / Code Intelligence
--   gd              → go to definition
--   gr              → go to references
--   K               → show hover documentation
--   <Space>ca       → code actions
--   <Space>cr       → rename symbol
--   <Space>cd       → show line diagnostics
--   [d / ]d         → previous / next diagnostic

-- Git (LazyGit + Gitsigns)
--   <Space>gg       → open LazyGit UI
--   <Space>gb       → git blame current line
--   ]h / [h         → next / previous git hunk

-- Terminal
--   Ctrl-/          → toggle floating terminal
--   Ctrl-\ Ctrl-n   → exit terminal insert mode (back to Normal)

-- Plugin Manager
--   <Space>l        → open Lazy plugin manager
