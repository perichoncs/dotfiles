return {
  -- Multi-cursor: select next occurrence of word/selection and add a cursor there.
  -- Similar to GoLand Alt+J / VS Code Ctrl+D.
  --
  -- Key workflow:
  --   1. (Normal)  <C-n> on a word  → selects it and enters multi-cursor mode
  --   2. (Visual)  <C-n>            → adds cursor at next occurrence
  --   3. Keep pressing <C-n> to add more occurrences
  --   4. <C-x> to skip current occurrence (without adding cursor)
  --   5. <C-p> to remove last added cursor
  --   6. Type / edit — all cursors move simultaneously
  --   7. <Esc> to exit multi-cursor mode
  --
  -- NOTE: <C-l> is taken by vim-tmux-navigator (right pane), so <C-n> is used instead.
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-n>", -- Normal: select word under cursor
        ["Find Subword Under"] = "<C-n>", -- Visual: select next occurrence
        ["Skip Region"]        = "<C-x>", -- skip current, go to next
        ["Remove Region"]      = "<C-p>", -- undo last cursor
        ["Select All"]         = "<leader>ma", -- select ALL occurrences at once
      }
      vim.g.VM_theme = "ocean"
    end,
  },
}
