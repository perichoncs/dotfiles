-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Fix: ESC key delay — set to 0 so terminal escape sequences (e.g. ESC+j/k)
-- are not mis-interpreted as Alt+j/k (which would move lines up/down).
-- Without this, pressing <Esc> quickly followed by j/k triggers <A-j>/<A-k>.
vim.opt.ttimeoutlen = 0


