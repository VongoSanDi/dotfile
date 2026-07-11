-- I chose this one over https://github.com/folke/snacks.nvim/blob/main/docs/indent.md and https://github.com/nvim-mini/mini.indentscope because it's faster
-- I trust Rust ?

vim.pack.add({ 'https://github.com/saghen/blink.indent' })
require('blink.indent').setup({})
