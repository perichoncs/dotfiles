-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Persist colorscheme selection so it survives restarts.
-- Works with <leader>uC (theme picker) or any :colorscheme command.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("persist_colorscheme", { clear = true }),
  callback = function()
    local scheme = vim.g.colors_name
    if scheme then
      local file = vim.fn.stdpath("data") .. "/colorscheme.txt"
      local f = io.open(file, "w")
      if f then
        f:write(scheme)
        f:close()
      end
    end
  end,
})
