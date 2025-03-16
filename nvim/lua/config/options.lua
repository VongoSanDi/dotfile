-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.background = "dark"
opt.spelllang = { "en_us", "fr" }
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.wrap = true -- Enable line wrapping
opt.breakindent = true -- Indentation visuelle des lignes repliées
opt.scrolloff = 5 -- Lines of context
opt.swapfile = false -- turn off swapfile
