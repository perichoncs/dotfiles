return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Show the full relative path in the winbar instead of just the filename
      local winbar = opts.winbar or {}
      winbar.lualine_c = {
        {
          "filename",
          path = 2, -- 0 = filename, 1 = relative path, 2 = absolute path
        },
      }
      opts.winbar = winbar
    end,
  },
}
