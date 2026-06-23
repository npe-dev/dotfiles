-- Multiple cursors (Sublime/VSCode style).
-- Default mappings:
--   Ctrl-n   : select word under cursor / next occurrence
--   Ctrl-Down / Ctrl-Up : add cursor vertically
--   n / N    : next / previous in visual-multi mode
--   q        : skip current and go to next
--   [ / ]    : navigate between cursors
return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
    }
  end,
}
