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
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },
}
