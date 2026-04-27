return {
  -- Fix: pressing Enter to accept a completion should NOT also insert a newline.
  -- Default blink.cmp behavior lets Enter fall through to the editor when the
  -- menu is open, which adds an unwanted blank line.
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" }, -- accept only, no newline passthrough
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },

  -- Disable LSP progress messages (e.g. "✓ pyright") that appear on every keypress.
  -- Diagnostics (errors, warnings) are NOT affected — only the status ticker is hidden.
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },
}
