-- Read persisted colorscheme from data dir (not config — won't be committed to git).
-- Falls back to "catppuccin" on first run.
local function get_persisted_colorscheme()
  local file = vim.fn.stdpath("data") .. "/colorscheme.txt"
  local f = io.open(file, "r")
  if f then
    local scheme = f:read("*l")
    f:close()
    if scheme and scheme ~= "" then
      return scheme
    end
  end
  return "catppuccin"
end

return {
  -- Themes (lazy=false so they all appear in the <leader>uC picker)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- Tell LazyVim which colorscheme to apply on startup
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = get_persisted_colorscheme(),
    },
  },
}
