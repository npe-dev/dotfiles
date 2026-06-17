-- Starter colorscheme. Add more plugin specs as sibling files in this folder;
-- lazy.nvim imports them all automatically.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other UI plugins
  config = function()
    require("catppuccin").setup({ flavour = "mocha" })
    vim.cmd.colorscheme("catppuccin")
  end,
}
