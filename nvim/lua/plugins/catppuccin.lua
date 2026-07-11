vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

require('catppuccin').setup {
  flavor = 'mocha',
  no_italic = true,
}

vim.cmd.colorscheme 'catppuccin-nvim'
