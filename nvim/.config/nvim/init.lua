-- ============================================================
--   Neovim entry point
--   Maintained by: NPE
--   Location: ~/dotfiles/nvim/.config/nvim
-- ============================================================

-- Leader keys must be set before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.lazy")
